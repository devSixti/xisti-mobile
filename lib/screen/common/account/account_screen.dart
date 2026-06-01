import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/custom_switch.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/utils.dart';
import '../profile/profile.dart';
import 'account_bloc.dart';
import 'account_dl.dart';
import 'item_account.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AccountBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= AccountBloc(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      appBar: CommonAppBar(
        centerTitle: true,
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        title: Text(languages.account, style: toolbarStyle(context: context)),
      ),
      body: _buildAccount(context),
    );
  }

  Widget _buildAccount(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 20.h, bottom: getBottomMargin()),
      child: Column(
        children: [
          // Profile Data
          GestureDetector(
            onTap: () {
              openScreen(context, const ProfileScreen());
            },
            child: ValueListenableBuilder(
              valueListenable: userInfoBox.listenable(),
              builder: (context, value, child) {
                return ColoredBox(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      LoadImageWithPlaceHolder(
                        image: getStringFromUserInfoBox(hiveProfileImage),
                        width: 60.sp,
                        height: 60.sp,
                        defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsetsDirectional.only(start: 15.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getStringFromUserInfoBox(hiveUserName, defaultValue: "-"),
                                textAlign: TextAlign.start,
                                style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600),
                              ),
                              if (getStringFromUserInfoBox(hiveContactNumber).isNotEmpty)
                                Padding(
                                  padding: EdgeInsetsDirectional.only(top: 10.h),
                                  child: Text(
                                    "\u2068${getStringFromUserInfoBox(hiveCountryCode)}-${getStringFromUserInfoBox(hiveContactNumber)}",
                                    textAlign: TextAlign.start,
                                    style: bodyText(context: context, fontSize: textSize14px, textColor: getCurrentTheme(context).colorTextCommon),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Transform(
                        alignment: AlignmentDirectional.center,
                        transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
                        child: Icon(CustomIcons.arrowForward, size: 18.sp, color: getCurrentTheme(context).colorIconCommon),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // BioMetric
          if (getIntFromSettingBox(hiveIsFingerAllow) == 1) ...[
            StreamBuilder<bool>(
              stream: _bloc?.isBiometricAuthAvailableController,
              builder: (context, snapshot) {
                bool isBiometricAuthAvailable = snapshot.data ?? false;
                return Padding(
                  padding: EdgeInsetsDirectional.symmetric(vertical: 30.sp),
                  child: Row(
                    children: [
                      Icon(
                        CustomIcons.fingerprint,
                        size: 25.sp,
                        color: isBiometricAuthAvailable ? getCurrentTheme(context).colorIconCommon : getCurrentTheme(context).colorIconCommon.withValues(alpha: 0.4),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(start: 15.w),
                          child: Text(
                            languages.loginWithTouchID,
                            textAlign: TextAlign.start,
                            style: bodyText(
                              context: context,
                              fontWeight: FontWeight.w400,
                              textColor: isBiometricAuthAvailable ? getCurrentTheme(context).colorTextCommon : getCurrentTheme(context).colorTextLight,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: StreamBuilder<bool>(
                          stream: _bloc?.loginWithBiometricController,
                          builder: (context, snap) {
                            bool isLoginWithBiometric = snap.data ?? false;
                            return CustomSwitch(
                              width: 40.w,
                              radius: 30.r,
                              activeColor: isBiometricAuthAvailable ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorSelectionPrimaryOpc,
                              disableColor: isBiometricAuthAvailable
                                  ? getCurrentTheme(context).colorIconLight
                                  : getCurrentTheme(context).colorIconLight.withValues(alpha: 0.5),
                              thumbColor: getCurrentTheme(context).colorWhite,
                              value: isLoginWithBiometric,
                              innerPadding: EdgeInsets.all(3.sp),
                              thumbSize: 15.sp,
                              onChanged: isBiometricAuthAvailable
                                  ? (value) {
                                      _bloc?.loginWithBiometricController.sink.add(value);
                                      putDataInSettingBox(hiveIsLoginWithBiometrics, value);
                                    }
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ] else ...[
            SizedBox(height: 20.h),
          ],

          // Account Options
          Expanded(
            child: StreamBuilder<List<AccountItem>>(
              stream: _bloc?.accountItemController,
              builder: (context, snapAccountItems) {
                List<AccountItem> accountList = snapAccountItems.data ?? [];
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: accountList.length,
                  separatorBuilder: (context, index) => Container(height: 20.h),
                  itemBuilder: (BuildContext context, position) {
                    return GestureDetector(
                      onTap: () {
                        _bloc?.openAccountSelectedScreen(snapAccountItems.data![position]);
                      },
                      child: ItemAccount(accountItem: accountList[position]),
                    );
                  },
                );
              },
            ),
          ),

          // User Mode Option
          StreamBuilder<ApiResponse<ActiveModePojo>>(
            stream: _bloc?.subjectMode,
            builder: (context, snapMode) {
              var isLoadingMode = snapMode.hasData && snapMode.data?.status == Status.loading;
              return StreamBuilder<ApiResponse<DriverServiceStatusPojo>>(
                stream: _bloc?.subjectStatus,
                builder: (context, snapStatus) {
                  var isLoadingStatus = snapStatus.hasData && snapStatus.data?.status == Status.loading;
                  return CustomRoundedButton(
                    context,
                    getIntFromSettingBox(hiveAppMode) == AppMode.driver ? languages.passengerMode : languages.driverMode,
                    (isLoadingMode || isLoadingStatus)
                        ? null
                        : () {
                            openRequiredInfoBottomSheet(context, () {
                              _bloc?.changeAppMode();
                            });
                          },
                    setProgress: (isLoadingMode || isLoadingStatus),
                    margin: EdgeInsetsDirectional.only(bottom: 10.h, top: 10.h),
                  );
                },
              );
            },
          ),

          // App Version
          appVersionName(),
        ],
      ),
    );
  }
}
