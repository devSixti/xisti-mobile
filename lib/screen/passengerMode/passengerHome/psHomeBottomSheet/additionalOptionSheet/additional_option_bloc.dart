import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

import '../../../../../blocs/bloc.dart';
import '../../../../../utils/utils.dart';

class AdditionalOptionBloc extends Bloc {
  BuildContext context;
  final Function(String comment, bool childSafety, bool handicap, bool bookForOther, String otherContact, String otherContactName) onSubmit;

  AdditionalOptionBloc(
    this.context, {
    required String comment,
    required bool childSafety,
    required bool handicap,
    required bool bookForOther,
    required String otherContact,
    required String otherContactName,
    required this.onSubmit,
  }) {
    commentController.text = comment;
    childSafetyController.sink.add(childSafety);
    handyCapAccessibilityController.sink.add(handicap);
    bookForOtherController.sink.add(bookForOther);
    if (bookForOther) {
      otherContactController.sink.add(otherContact);
      otherNameController.text = otherContactName;
    }
  }

  final childSafetyController = BehaviorSubject<bool>();
  final handyCapAccessibilityController = BehaviorSubject<bool>();
  final bookForOtherController = BehaviorSubject<bool>();
  final commentController = TextEditingController();
  final otherNameController = TextEditingController();
  final otherContactController = BehaviorSubject<String>();

  Future<void> pickContactNumber() async {
    final FlutterNativeContactPicker contactPicker = FlutterNativeContactPicker();
    Contact? contact = await contactPicker.selectContact();
    if (contact != null) {
      otherNameController.text = contact.fullName ?? "";
      contactNumberOfOther(contact.phoneNumbers?.first ?? "");
    }
  }

  void contactNumberOfOther(String value) {
    if (!value.startsWith("+")) {
      value = "${defaultCountryCode.dialCode}$value";
    }
    value = value.replaceAll(" ", "");
    value = value.replaceAll("(", "");
    value = value.replaceAll(")", "");
    value = value.replaceAll("-", "");
    value = value.replaceAll(".", "");
    value = value.replaceAll("/", "");
    value = value.replaceAll(",", "");
    value = value.replaceAll(";", "");
    otherContactController.sink.add(value);
  }

  void onContinuePress() {
    if (bookForOtherController.valueOrNull ?? false) {
      if ((otherContactController.valueOrNull ?? "").isEmpty) {
        openSimpleSnackbar(context, languages.selectContactNumber);
        return;
      } else if (otherNameController.text.trim().isEmpty) {
        openSimpleSnackbar(context, languages.enterContactName);
        return;
      }
    }
    onSubmit(
      commentController.text,
      childSafetyController.valueOrNull ?? false,
      handyCapAccessibilityController.valueOrNull ?? false,
      bookForOtherController.valueOrNull ?? false,
      (bookForOtherController.valueOrNull ?? false) ? otherContactController.valueOrNull ?? "" : "",
      (bookForOtherController.valueOrNull ?? false) ? otherNameController.text.trim() : "",
    );
  }

  @override
  void dispose() {
    childSafetyController.close();
    handyCapAccessibilityController.close();
    bookForOtherController.close();
    commentController.dispose();
    otherContactController.close();
  }
}
