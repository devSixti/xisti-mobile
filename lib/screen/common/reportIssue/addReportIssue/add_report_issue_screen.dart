import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonView/common_view.dart';
import '../../../../commonView/custom_rounded_button.dart';
import '../../../../commonView/custom_text_field.dart';
import '../../../../commonView/load_image_with_placeholder.dart';
import '../../../../commonView/no_record_found.dart';
import '../../../../commonView/zoom_image_view.dart';
import '../../../../hive/hive_helper.dart';
import '../../../../networking/api_response.dart';
import '../../../../networking/base_dl.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/validator.dart';
import '../../../driverMode/driverHome/driver_home.dart';
import '../../../passengerMode/passengerHome/passenger_home.dart';
import '../../chatting/chatting_screen.dart';
import '../reportedIssueHistory/reported_issue_history.dart';
import 'add_report_issue_bloc.dart';
import 'add_report_issue_dl.dart';
import 'add_report_issue_shimmer.dart';

class AddReportIssueScreen extends StatefulWidget {
  final String rideNo;
  final int rideId, reportId;
  final bool isFromIssueHistory, isFromNotification, isResolved, isFromDetail;

  const AddReportIssueScreen({
    super.key,
    this.rideNo = "",
    this.rideId = 0,
    this.reportId = 0,
    required this.isFromIssueHistory,
    this.isFromNotification = false,
    this.isResolved = false,
    this.isFromDetail = false,
  });

  @override
  State<AddReportIssueScreen> createState() => _AddReportIssueScreenState();
}

class _AddReportIssueScreenState extends State<AddReportIssueScreen> {
  AddReportIssueBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= AddReportIssueBloc(context, widget.rideNo, widget.rideId, widget.isFromIssueHistory, widget.reportId, widget.isFromDetail);
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
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        if (widget.isFromNotification) {
          openScreenWithClearPrevious(context, getIntFromSettingBox(hiveAppMode) == AppMode.driver ? const DriverHome() : const PassengerHome());
        } else if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          openScreenWithClearPrevious(context, const ReportedIssueHistory());
        }
      },
      child: ScaffoldWithSafeArea(
        appBar: CommonAppBar(
          centerTitle: true,
          leading: backButtonForAppBarCustom(
            context: context,
            onBackPress: () {
              if (widget.isFromNotification) {
                openScreenWithClearPrevious(context, getIntFromSettingBox(hiveAppMode) == AppMode.driver ? const DriverHome() : const PassengerHome());
              } else if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                openScreenWithClearPrevious(context, const ReportedIssueHistory());
              }
            },
          ),
          titleSpacing: 0,
          title: Text(languages.reportIssue, textAlign: TextAlign.center, style: toolbarStyle(context: context)),
        ),
        body: _addReportIssue(context),
      ),
    );
  }

  Widget _addReportIssue(BuildContext context) {
    return StreamBuilder<ApiResponse<ReportIssueDetailsPojo>>(
      stream: _bloc?.reportDetailsSubject,
      builder: (context, snapDetails) {
        ReportIssueDetailsPojo? data = snapDetails.data?.data;
        switch (snapDetails.data?.status ?? Status.loading) {
          case Status.loading:
            return AddReportIssueShimmer();
          case Status.error:
            return NoRecordFound(message: snapDetails.data?.message ?? "");
          case Status.completed:
            return addViewReportIssue(data);
        }
      },
    );
  }

  Widget addViewReportIssue(ReportIssueDetailsPojo? data) {
    bool isFromIssueHistory = widget.isFromIssueHistory;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: 20.h, horizontal: commonHorizontalPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (isFromIssueHistory) ...[_ticketTextFormField(), SizedBox(height: 20.h)],
                if (data?.rideNo != 0 && widget.rideNo != "0") ...[_orderNoTextFormField(), SizedBox(height: 20.h)],

                _descriptionTextFormField(),
                SizedBox(height: 20.h),

                _issueImageList(isFromIssueHistory, data),
              ],
            ),
          ),
        ),
        if (!widget.isResolved) Align(alignment: AlignmentDirectional.bottomCenter, child: _button(context, data, isFromIssueHistory: isFromIssueHistory)),
      ],
    );
  }

  Widget _ticketTextFormField() {
    return TextFormFieldCustom(
      controller: _bloc?.ticketIdTEC,
      decoration: InputDecoration(labelText: languages.ticketId),
      commonPrefixIcon: CustomIcons.ticketId,
      readOnly: true,
    );
  }

  Widget _orderNoTextFormField() {
    return TextFormFieldCustom(
      controller: _bloc?.orderNoTEC,
      decoration: InputDecoration(labelText: languages.rideId),
      commonPrefixIcon: CustomIcons.orderId,
      readOnly: true,
    );
  }

  Widget _descriptionTextFormField() {
    int maxLength = 200;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: getCurrentTheme(context).colorTextFieldBorder, width: 1.sp),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 10.h, bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(top: 5.h),
            child: Icon(CustomIcons.description, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
          ),
          Expanded(
            child: TextFormFieldCustom(
              controller: _bloc?.descriptionTEC,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              maxLine: 5,
              minLine: 5,
              setError: true,
              maxLength: maxLength,
              hint: languages.description,
              readOnly: widget.isFromIssueHistory ? true : false,
              validator: (value) {
                _bloc?.buttonHide();
                return validateEmptyField(value, languages.enterDescription);
              },
              contentPadding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _issueImageList(bool isFromIssueHistory, ReportIssueDetailsPojo? data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<int>(
          stream: _bloc?.loadingImageSubject,
          builder: (context, snapIndex) {
            int loadIndex = snapIndex.data ?? -1;
            return StreamBuilder<ApiResponse<UploadImagesPojo>>(
              stream: _bloc?.imageApiSubject,
              builder: (context, snapImageList) {
                List<ImageList> imageList = [];
                if (snapImageList.hasData && snapImageList.data?.status != Status.loading) {
                  imageList = snapImageList.data?.data?.image ?? [];
                }

                List<ImageList> generated = List.generate(
                  _bloc?.maxIssueImageUploadSubject.valueOrNull ?? 6,
                  (index) => imageList.length >= (index + 1) ? imageList[index] : ImageList(),
                );

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 20.sp, mainAxisSpacing: 15.sp),
                  itemCount: isFromIssueHistory ? data?.images.length : generated.length,
                  itemBuilder: (context, index) {
                    if (loadIndex == index) {
                      return _imageUploadShimmer();
                    } else if (generated[index].image.isEmpty && !isFromIssueHistory) {
                      return _addImageView();
                    } else {
                      return _uploadImageView(
                        index: index,
                        isFromIssueHistory: widget.isFromIssueHistory,
                        uploadedImageList: data?.images ?? [],
                        imageList: generated,
                      );
                    }
                  },
                );
              },
            );
          },
        ),
        if (!isFromIssueHistory) ...[
          SizedBox(height: 20.h),
          Row(
            children: [
              Icon(CustomIcons.information, color: getCurrentTheme(context).colorIconCommon, size: 20.sp),
              SizedBox(width: 5.w),
              Expanded(
                child: Text(
                  languages.uploadMinImagesMsg(_bloc?.minIssueImageUploadSubject.valueOrNull ?? 0),
                  style: bodyText(context: context, fontSize: textSize14px),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _imageUploadShimmer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r), color: getCurrentTheme(context).colorShimmerBg),
    );
  }

  Widget _addImageView() {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _bloc?.selectDocument();
      },
      child: Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: getCurrentTheme(context).colorScaffoldBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: getCurrentTheme(context).colorBorder, width: 1.sp),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(CustomIcons.upload, size: 25.sp, color: getCurrentTheme(context).colorIconLight)]),
      ),
    );
  }

  Widget _uploadImageView({required int index, required bool isFromIssueHistory, required List<Images> uploadedImageList, required List<ImageList> imageList}) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).push(
              PageRouteBuilder<void>(
                opaque: false,
                transitionDuration: const Duration(milliseconds: 400),
                reverseTransitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: const Interval(0.0, 1.0, curve: Curves.linear).transform(animation.value),
                        child: ZoomImageView(image: isFromIssueHistory ? uploadedImageList[index].image : imageList[index].image),
                      );
                    },
                  );
                },
              ),
            );
          },
          child: LoadImageWithPlaceHolder(
            width: double.infinity,
            height: double.infinity,
            image: isFromIssueHistory ? uploadedImageList[index].image : imageList[index].image,
            borderRadius: BorderRadius.circular(20.r),
            defaultAssetImage: "assets/images/app_icon.png",
          ),
        ),
        if (!isFromIssueHistory)
          GestureDetector(
            onTap: () {
              _bloc?.openRemoveImageBottomSheet(imageIndex: index, imageId: imageList[index].id);
            },
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: Container(
                margin: EdgeInsetsDirectional.all(5.sp),
                padding: EdgeInsetsDirectional.all(5.sp),
                decoration: BoxDecoration(
                  color: getCurrentTheme(context).colorStaticWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: getCurrentTheme(context).colorStaticBlack, width: 0.1.sp),
                ),
                child: Icon(CustomIcons.delete, size: 12.sp, color: getCurrentTheme(context).colorStaticBlack),
              ),
            ),
          ),
      ],
    );
  }

  Widget _button(BuildContext context, ReportIssueDetailsPojo? data, {required bool isFromIssueHistory}) {
    return StreamBuilder<bool>(
      stream: _bloc?.isValidSubject,
      builder: (context, snapValid) {
        bool isEnable = snapValid.data ?? false;
        return StreamBuilder<ApiResponse<BaseModel>>(
          stream: _bloc?.updateIssueReportSubject,
          builder: (context, snapData) {
            bool isLoading = snapData.data?.status == Status.loading;
            return CustomRoundedButton(
              context,
              isFromIssueHistory ? languages.chat : languages.submitIssue,
              isEnable
                  ? null
                  : () {
                    if (isFromIssueHistory) {
                      openScreen(
                        context,
                        ChattingScreen(
                          chatWithName: 'Admin',
                          chatNo: data?.reportChatNo ?? "",
                          chatWithId: 'a_1',
                          showImagePick: true,
                          isReportIssueChat: true,
                          reportId: widget.reportId,
                        ),
                      );
                    } else {
                      _bloc?.reportIssueApiCall();
                    }
                  },
              setProgress: isLoading,
              minWidth: double.maxFinite,
              margin: EdgeInsetsDirectional.symmetric(vertical: getBottomMargin(), horizontal: commonHorizontalPadding),
            );
          },
        );
      },
    );
  }
}
