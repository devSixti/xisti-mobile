import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/no_record_found.dart';
import '../../../networking/api_response.dart';
import '../../../utils/utils.dart';
import '../driverRideDetail/driver_ride_detail.dart';
import 'feedback_bloc.dart';
import 'feedback_dl.dart';
import 'feedback_shimmer.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  FeedbackBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= FeedbackBloc(context);
    super.didChangeDependencies();
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
        title: Text(languages.feedback, style: toolbarStyle(context: context)),
      ),
      body: StreamBuilder<ApiResponse<FeedbackPojo>>(
        stream: _bloc?.subject,
        builder: (context, snapFeedback) {
          List<FeedbackListItem> feedbackList = snapFeedback.data?.data?.feedbackList ?? [];
          return switch (snapFeedback.data?.status ?? Status.loading) {
            Status.loading => FeedbackShimmer(),
            Status.completed => feedbackList.isEmpty ? NoRecordFound(message: languages.noRecordFound) : _feedbackListWidget(feedbackList),
            Status.error => NoRecordFound(message: snapFeedback.data?.message ?? languages.noRecordFound),
          };
        },
      ),
    );
  }

  Widget _feedbackListWidget(List<FeedbackListItem> feedbackList) {
    return ListView.separated(
      itemCount: feedbackList.length,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        FeedbackListItem feedbackListItem = feedbackList[index];
        return Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  LoadImageWithPlaceHolder(
                    width: 70.sp,
                    height: 70.sp,
                    image: feedbackListItem.userProfileImage,
                    defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  SizedBox(width: 10.w),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(feedbackListItem.userName, style: bodyText(context: context, fontWeight: FontWeight.w600))),
                            SizedBox(width: 10.w),
                            GestureDetector(
                              onTap: () {
                                openScreen(context, DriverRideDetail(rideId: feedbackListItem.rideId));
                              },
                              child: Container(
                                margin: EdgeInsetsDirectional.only(start: 10.w),
                                padding: EdgeInsetsDirectional.symmetric(vertical: 6.h, horizontal: 17.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.circular(50.r),
                                  border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 1.sp),
                                ),
                                child: Text(languages.viewRide, style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: 14.sp)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(CustomIcons.rating, color: getCurrentTheme(context).colorRating, size: 20.sp),
                            SizedBox(width: 3.w),
                            Text("${feedbackListItem.rating}", style: bodyText(context: context, fontSize: 14.sp)),
                            // SizedBox(width: 3.w),
                            // Text("(${feedbackListItem.totalRatings})", style: bodyText(context: context, fontSize: 14.sp)),
                            SizedBox(width: 8.w),
                            Container(
                              height: 4.sp,
                              width: 4.sp,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: getCurrentTheme(context).colorIconCommon),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              getDateTimeWithoutTimezone(feedbackListItem.datetime, format: "EEE dd MMM, yyyy", returnFormat: "dd MMM, yyyy"),
                              style: bodyText(context: context, fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (feedbackListItem.comment.isNotEmpty)
                Padding(
                  padding: EdgeInsetsDirectional.only(top: 10.h),
                  child: ReadMoreText(
                    "\"${feedbackListItem.comment}\"",
                    trimLines: 2,
                    style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w500),
                    trimMode: TrimMode.Line,
                    trimCollapsedText: languages.showMore,
                    trimExpandedText: languages.showLess,
                    lessStyle: bodyText(context: context, fontWeight: FontWeight.w600),
                    moreStyle: bodyText(context: context, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(color: getCurrentTheme(context).colorManageAddressDivider);
      },
    );
  }
}
