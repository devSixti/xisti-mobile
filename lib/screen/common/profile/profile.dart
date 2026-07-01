import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/customCountryCodePicker/custom_country_code_picker.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/custom_text_field.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/api_response.dart';
import '../../../utils/utils.dart';
import '../../../utils/validator.dart';
import '../Login/login_dl.dart';
import 'profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= ProfileBloc(context: context);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _bloc?.isChangedData);
      },
      child: ScaffoldWithSafeArea(
        appBar: CommonAppBar(
          centerTitle: true,
          leading: backButtonForAppBarCustom(
            context: context,
            onBackPress: () {
              Navigator.pop(context, _bloc?.isChangedData);
            },
          ),
          title: Text(languages.myDetails, style: toolbarStyle(context: context)),
        ),
        body: _buildProfile(context),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 20.h, bottom: 100.h),
          child: Form(
            key: _bloc?.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _userProfileImage(),
                SizedBox(height: 30.h),
                _userName(),
                SizedBox(height: 20.h),
                _userEmail(),
                SizedBox(height: 20.h),
                _userContact(),
                SizedBox(height: 20.h),
                _userEmergencyContactName(),
                SizedBox(height: 20.h),
                _userEmergencyContact(),
              ],
            ),
          ),
        ),
        Align(alignment: Alignment.bottomCenter, child: _updateButton()),
      ],
    );
  }

  Widget _userProfileImage() {
    final photoSize = 100.sp;
    final editButtonSize = 40.sp;

    return GestureDetector(
      onTap: () {
        _bloc?.addProfileImage();
      },
      child: StreamBuilder<File?>(
        stream: _bloc?.imgFileController,
        builder: (context, localSnap) {
          return StreamBuilder<String>(
            stream: _bloc?.profileImgController,
            builder: (context, networkSnap) {
              return SizedBox(
                width: photoSize,
                height: photoSize + (editButtonSize / 2),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: _profileAvatarContent(
                          context: context,
                          photoSize: photoSize,
                          localFile: localSnap.data,
                          networkUrl: networkSnap.data ?? "",
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: editButtonSize,
                        height: editButtonSize,
                        child: Container(
                          padding: EdgeInsetsDirectional.all(10.sp),
                          decoration: BoxDecoration(
                            color: getCurrentTheme(context).colorPrimary,
                            borderRadius: BorderRadius.all(Radius.circular(15.r)),
                          ),
                          child: Icon(CustomIcons.edit, color: getCurrentTheme(context).colorWhite, size: 20.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _profileAvatarContent({
    required BuildContext context,
    required double photoSize,
    required File? localFile,
    required String networkUrl,
  }) {
    if (localFile != null) {
      return ColoredBox(
        color: getCurrentTheme(context).colorScaffoldBg,
        child: Image.file(
          localFile,
          width: photoSize,
          height: photoSize,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
        ),
      );
    }

    return LoadImageWithPlaceHolder(
      width: photoSize,
      height: photoSize,
      image: networkUrl,
      defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
      borderRadius: BorderRadius.zero,
      imageFit: BoxFit.cover,
    );
  }

  Widget _userName() {
    return TextFormFieldCustom(
      controller: _bloc?.fullNameTEC,
      hint: languages.enterYourName,
      commonPrefixIcon: CustomIcons.name,
      suffix: Padding(
        padding: EdgeInsetsDirectional.only(end: 15.w),
        child: Icon(CustomIcons.edit, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
      ],
      setError: true,
      validator: (value) {
        _bloc?.buttonHide();
        return registerFullNameValidate(value,languages.enterValidFullName);
      },
    );
  }

  Widget _userEmail() {
    bool isReadOnly = (getStringFromUserInfoBox(hiveLoginType) != LoginType.email && getStringFromUserInfoBox(hiveEmail).isNotEmpty);

    return TextFormFieldCustom(
      controller: _bloc?.emailTEC,
      hint: languages.enterEmailAddress,
      commonPrefixIcon: CustomIcons.email,
      readOnly: isReadOnly,
      suffix:
          isReadOnly
              ? null
              : Padding(
                padding: EdgeInsetsDirectional.only(end: 15.w),
                child: Icon(CustomIcons.edit, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
              ),
      setError: true,
      validator: (value) {
        _bloc?.buttonHide();
        return emailValidate(value);
      },
    );
  }

  Widget _userContact() {
    return TextFormFieldCustom(
      controller: _bloc?.contactNoTEC,
      setError: true,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      hint: languages.contactNumber,
      prefix: CustomCountryCodePicker(
        showDropDownButton: true,
        flagWidth: 35.w,
        padding: EdgeInsets.zero,
        onChanged: (countryCode) {
          _bloc?.contactCountryCodeController.sink.add(countryCode);
        },
        onInit: (countryCode) {
          _bloc?.contactCountryCodeController.sink.add(countryCode!);
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
      suffix: Padding(
        padding: EdgeInsetsDirectional.only(end: 15.w),
        child: Icon(CustomIcons.edit, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
      ),
      textAlignVertical: TextAlignVertical.center,
      validator: (value) {
        _bloc?.buttonHide();
        return colombiaMobileNumberValidate(
          value,
          dialCode: _bloc?.contactCountryCodeController.valueOrNull?.dialCode,
        );
      },
    );
  }

  Widget _userEmergencyContactName() {
    return TextFormFieldCustom(
      controller: _bloc?.emergencyContactNameTEC,
      setError: true,
      hint: languages.emergencyContactName,
      prefix: Padding(
        padding: EdgeInsetsDirectional.only(start: 15.w, end: 10.w),
        child: Icon(Icons.person_outline, color: getCurrentTheme(context).colorIconCommon, size: 24.sp),
      ),
      onChanged: (_) => _bloc?.buttonHide(),
    );
  }

  Widget _userEmergencyContact() {
    return TextFormFieldCustom(
      controller: _bloc?.emergencyContactNoTEC,
      setError: true,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      hint: languages.emergencyContact,
      prefix: CustomCountryCodePicker(
        showDropDownButton: true,
        flagWidth: 35.w,
        padding: EdgeInsets.zero,
        onChanged: (countryCode) {
          _bloc?.emergencyContactCountryCodeController.sink.add(countryCode);
        },
        onInit: (countryCode) {
          _bloc?.emergencyContactCountryCodeController.sink.add(countryCode!);
        },
        initialSelection:
            getStringFromUserInfoBox(hiveEmergencyCountryCode).trim().isNotEmpty ? getStringFromUserInfoBox(hiveEmergencyCountryCode) : defaultCountryCode.name,
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
      suffix: Padding(
        padding: EdgeInsetsDirectional.only(end: 15.w),
        child: Icon(CustomIcons.edit, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
      ),
      textAlignVertical: TextAlignVertical.center,
    );
  }

  Widget _updateButton() {
    return StreamBuilder<bool>(
      stream: _bloc?.submitValidController,
      builder: (context, snap) {
        bool isEnable = snap.data ?? false;
        return StreamBuilder<ApiResponse<LoginPojo>>(
          stream: _bloc?.profileDetailsUpdateSubject,
          builder: (context, snapLoading) {
            bool isLoading = snapLoading.data?.status == Status.loading;

            return CustomRoundedButton(
              context,
              languages.update,
              (isLoading || !isEnable)
                  ? null
                  : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_bloc?.formKey.currentState?.validate() ?? false) {
                      _bloc?.updateProfileDetailsApiCall();
                    }
                  },
              setProgress: isLoading,
              margin: EdgeInsetsDirectional.symmetric(vertical: getBottomMargin(), horizontal: commonHorizontalPadding),
            );
          },
        );
      },
    );
  }
}
