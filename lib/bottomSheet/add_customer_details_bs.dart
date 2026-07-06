import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/bloc.dart';
import '../commonView/customCountryCodePicker/custom_country_code_picker.dart';
import '../commonView/custom_rounded_button.dart';
import '../commonView/custom_text_field.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../hive/hive_helper.dart';
import '../utils/utils.dart';
import '../utils/validator.dart';

class AddCustomerDetailsBS extends StatefulWidget {
  final Function(String name, String countryCode, String phoneNumber)? onSubmit;

  const AddCustomerDetailsBS({super.key, this.onSubmit});

  @override
  State<AddCustomerDetailsBS> createState() => _AddCustomerDetailsBSState();
}

class _AddCustomerDetailsBSState extends State<AddCustomerDetailsBS> {
  final fullNameTEC = TextEditingController();
  final contactNoTEC = TextEditingController();
  final contactCountryCodeController = BehaviorSubject<CountryCode>.seeded(defaultCountryCode);
  final submitValidController = BehaviorSubject<bool>.seeded(false);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ScaffoldWithSafeArea(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
                padding: bottomSheetPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _bottomSheetTitleView(),
                    SizedBox(height: 20.h),
                    _userName(),
                    SizedBox(height: 20.h),
                    _userContact(),
                    SizedBox(height: 30.h),
                    _actionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomSheetTitleView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            languages.addCustomerDetails,
            textAlign: TextAlign.start,
            style: bodyText(context: context, fontSize: textSize18px, textColor: getCurrentTheme(context).colorTextCommon, fontWeight: FontWeight.w700),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
        ),
      ],
    );
  }

  Widget _userName() {
    return TextFormFieldCustom(
      controller: fullNameTEC,
      hint: languages.enterYourName,
      commonPrefixIcon: CustomIcons.name,
      setError: true,
      validator: (value) {
        buttonHide();
        return fullNameValidate(value);
      },
    );
  }

  Widget _userContact() {
    return TextFormFieldCustom(
      controller: contactNoTEC,
      setError: true,
      keyboardType: TextInputType.phone,
      inputFormatters: phoneInputFormatters(),
      hint: languages.contactNumber,
      prefix: CustomCountryCodePicker(
        showDropDownButton: true,
        flagWidth: 35.w,
        padding: EdgeInsets.zero,
        onChanged: (countryCode) {
          contactCountryCodeController.sink.add(countryCode);
        },
        onInit: (countryCode) {
          contactCountryCodeController.sink.add(countryCode!);
        },
        initialSelection: getStringFromUserInfoBox(hiveCountryCode).trim().isNotEmpty ? getStringFromUserInfoBox(hiveCountryCode) : defaultCountryCode.name,
        builder: (countryCode) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 15.w, end: 10.w, top: 10.h, bottom: 10.h),
                child: Icon(CustomIcons.call, color: getCurrentTheme(context).colorIconCommon, size: 24.sp),
              ),
              Text(countryCode?.dialCode ?? "", style: bodyText(context: context, fontWeight: FontWeight.w500)),
              Padding(padding: EdgeInsetsDirectional.only(start: 5.w), child: Icon(Icons.arrow_drop_down, color: Colors.grey, size: 25.sp)),
            ],
          );
        },
      ),
      textAlignVertical: TextAlignVertical.center,
      validator: (value) {
        buttonHide();
        return mobileNumberValidate(value);
      },
    );
  }

  Widget _actionButtons() {
    return StreamBuilder<bool>(
      stream: submitValidController,
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CustomRoundedButton(context, languages.no, () {
                Navigator.pop(context);
              }, setBorder: true),
            ),
            SizedBox(width: 25.w),
            Expanded(
              child: CustomRoundedButton(
                context,
                languages.yes,
                (snapshot.data ?? false)
                    ? () {
                      widget.onSubmit?.call(
                        fullNameTEC.text,
                        (contactCountryCodeController.valueOrNull?.dialCode ?? defaultCountryCode.dialCode ?? ''),
                        contactNoTEC.text,
                      );
                    }
                    : null,
                progressSize: cpiSizeRegular,
              ),
            ),
          ],
        );
      },
    );
  }

  void buttonHide() {
    String fullName = fullNameValidate(fullNameTEC.text);
    String mobile = mobileNumberValidate(contactNoTEC.text);

    if (fullName.isEmpty && mobile.isEmpty) {
      submitValidController.add(true);
    } else {
      submitValidController.add(false);
    }
  }
}
