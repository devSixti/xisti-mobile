import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/customCountryCodePicker/country_code.dart';
import '../../../constant/chat_constant.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/phone_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/validator.dart';
import '../Login/login_dl.dart';
import '../faceVerification/face_verification_view.dart';
import 'profile_dl.dart';
import 'profile_repo.dart';

class ProfileBloc extends Bloc {
  final BuildContext context;

  ProfileBloc({required this.context}) {
    setProfileData();

    getDetailApiCall();
  }

  bool isChangedData = false;

  final _repo = ProfileRepo();
  final formKey = GlobalKey<FormState>();

  DatabaseReference? _referenceUser;
  String userId = ChatConstant.userIdCode + getIntFromUserInfoBox(hiveUserId).toString();

  final submitValidController = BehaviorSubject<bool>();
  final profileImgController = BehaviorSubject<String>();
  final imgFileController = BehaviorSubject<File?>();
  final contactCountryCodeController = BehaviorSubject<CountryCode>();
  final emergencyContactCountryCodeController = BehaviorSubject<CountryCode>();

  final profileDetailsUpdateSubject = BehaviorSubject<ApiResponse<LoginPojo>>();
  final getUserDetailsSubject = BehaviorSubject<ApiResponse<ProfilePojo>>();

  final fullNameTEC = TextEditingController();
  final emailTEC = TextEditingController();
  final contactNoTEC = TextEditingController();
  final emergencyContactNoTEC = TextEditingController();
  final emergencyContactNameTEC = TextEditingController();

  void addProfileImage() {
    openScreenWithResult(
      context,
      FaceVerificationView(
        onVerified: (image, rotation) async {
          File compressFile = await compressImage(image);
          imgFileController.sink.add(compressFile);
          buttonHide();
        },
        onCancel: () {
          debugPrint("FaceVerificationView onCancel called");
        },
      ),
    );
    // selectImgFromCameraOrGallery(
    //   context,
    //   (file) async {
    //     if (file.path.isNotEmpty) {
    //       File compressFile = await compressImage(file);
    //       imgFileController.sink.add(compressFile);
    //     }
    //   },
    //   isSquare: true,
    // );
  }

  void buttonHide() {
    String fullName = fullNameValidate(fullNameTEC.text);
    String email = emailValidate(emailTEC.text);
    String mobile = colombiaMobileNumberValidate(contactNoTEC.text);

    if (fullName.isEmpty && email.isEmpty && mobile.isEmpty) {
      submitValidController.add(true);
    } else {
      submitValidController.add(false);
    }
  }

  void checkAndSetUserAtFirebase() {
    _referenceUser ??= FirebaseDatabase.instance.ref().child(ChatConstant.chat).child(ChatConstant.users).child("a_1");

    _referenceUser?.orderByChild(ChatConstant.userId).equalTo(userId).once().then((dataSnapshot) {
      if (dataSnapshot.snapshot.value != null) {
        Map data = dataSnapshot.snapshot.value as Map<dynamic, dynamic>;
        var updateMap = <String, dynamic>{};
        updateMap[ChatConstant.userProfile] = getStringFromUserInfoBox(hiveProfileImage);
        updateMap[ChatConstant.userName] = getStringFromUserInfoBox(hiveUserName);
        _referenceUser?.orderByChild(ChatConstant.userId).equalTo(userId).ref.child(data.keys.elementAt(0)).update(updateMap);
      }
    });
  }

  void setProfileData() {
    profileImgController.sink.add(getStringFromUserInfoBox(hiveProfileImage));
    fullNameTEC.text = getStringFromUserInfoBox(hiveUserName);
    emailTEC.text = getStringFromUserInfoBox(hiveEmail);
    contactNoTEC.text = getStringFromUserInfoBox(hiveContactNumber);
    emergencyContactNoTEC.text = getStringFromUserInfoBox(hiveEmergencyContact);
    emergencyContactNameTEC.text = getStringFromUserInfoBox(hiveEmergencyContactName);

    contactCountryCodeController.sink.add(
      getStringFromUserInfoBox(hiveCountryCode).trim().isNotEmpty ? CountryCode(dialCode: getStringFromUserInfoBox(hiveCountryCode)) : defaultCountryCode,
    );

    emergencyContactCountryCodeController.sink.add(
      getStringFromUserInfoBox(hiveEmergencyCountryCode).trim().isNotEmpty
          ? CountryCode(dialCode: getStringFromUserInfoBox(hiveEmergencyCountryCode))
          : defaultCountryCode,
    );

    buttonHide();
    checkAndSetUserAtFirebase();
  }

  Future<void> getDetailApiCall() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getDetailApiCall())) {
      getUserDetailsSubject.sink.add(ApiResponse.loading());
      try {
        var response = ProfilePojo.fromJson(await _repo.getUserDetailApi());

        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status ?? 0, message, true)) {
          getUserDetailsSubject.sink.add(ApiResponse.completed(response));
          putDataInUserInfoBox(hiveUserName, response.userDetails?.firstName ?? "");
          putDataInUserInfoBox(hiveProfileImage, response.userDetails?.profileImage ?? "");
          putDataInUserInfoBox(hiveCountryCode, response.userDetails?.countryCode ?? "");
          putDataInUserInfoBox(hiveContactNumber, response.userDetails?.contactNumber ?? "");
          putDataInUserInfoBox(hiveEmail, response.userDetails?.email ?? "");
          putDataInUserInfoBox(hiveEmergencyContact, response.userDetails?.emergencyContact ?? "");
          putDataInUserInfoBox(hiveEmergencyContactName, response.userDetails?.emergencyContactName ?? "");
          putDataInUserInfoBox(hiveEmergencyCountryCode, response.userDetails?.emergencyCountryCode ?? "");
          setProfileData();
        } else {
          getUserDetailsSubject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        getUserDetailsSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> updateProfileDetailsApiCall() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => updateProfileDetailsApiCall())) {
      MultipartFile? multipartFile;
      if (getStringFromUserInfoBox(hiveProfileImage).trim().isEmpty && imgFileController.valueOrNull == null) {
        if (context.mounted) openSimpleSnackbar(context, languages.pleaseAddProfileImage);
        return;
      } else if (imgFileController.valueOrNull != null) {
        multipartFile = MultipartFile.fromFileSync(imgFileController.valueOrNull!.path, filename: imgFileController.valueOrNull!.path.split('/').last);
      }

      profileDetailsUpdateSubject.sink.add(ApiResponse.loading());
      try {
        final contactDial = normalizeDialCode(contactCountryCodeController.valueOrNull?.dialCode ?? defaultCountryCode.dialCode);
        final emergencyDial = normalizeDialCode(emergencyContactCountryCodeController.valueOrNull?.dialCode ?? defaultCountryCode.dialCode);
        var response = LoginPojo.fromJson(
          await _repo.editProfileApi(
            fullNameTEC.text.trim(),
            contactDial,
            normalizeColombiaLocalMobile(contactNoTEC.text.trim(), dialCode: contactDial),
            emailTEC.text.trim(),
            emergencyContactNoTEC.text.trim().isEmpty
                ? ""
                : normalizeColombiaLocalMobile(emergencyContactNoTEC.text.trim(), dialCode: emergencyDial),
            emergencyContactNameTEC.text.trim(),
            emergencyDial,
            multipartFile,
            (double progress) => profileDetailsUpdateSubject.sink.add(ApiResponse.loading(progress: progress)),
          ),
        );

        String message = getApiMsg(response.message);

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          imgFileController.sink.add(null);

          profileDetailsUpdateSubject.sink.add(ApiResponse.completed(response));

          putDataInUserInfoBox(hiveUserName, response.userName ?? "");
          putDataInUserInfoBox(hiveProfileImage, response.profileImage ?? "");
          putDataInUserInfoBox(hiveCountryCode, response.selectCountryCode ?? "");
          putDataInUserInfoBox(hiveContactNumber, response.contactNumber ?? "");
          putDataInUserInfoBox(hiveEmail, response.email ?? "");
          putDataInUserInfoBox(hiveEmergencyContact, response.emergencyContact ?? "");
          putDataInUserInfoBox(hiveEmergencyContactName, response.emergencyContactName ?? "");
          putDataInUserInfoBox(hiveEmergencyCountryCode, response.emergencyCountryCode ?? "");
          isChangedData = true;
          setProfileData();
          openSimpleSnackbar(context, languages.profileUpdateSuccessfully);
        } else {
          profileDetailsUpdateSubject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        profileDetailsUpdateSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    submitValidController.close();
    profileImgController.close();
    imgFileController.close();
    contactCountryCodeController.close();
    emergencyContactCountryCodeController.close();
    profileDetailsUpdateSubject.close();
    getUserDetailsSubject.close();

    fullNameTEC.dispose();
    emailTEC.dispose();
    contactNoTEC.dispose();
    emergencyContactNoTEC.dispose();
    emergencyContactNameTEC.dispose();
  }
}
