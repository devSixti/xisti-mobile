import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/no_record_found.dart';
import '../../../commonView/statusView/referral_status_view.dart';
import '../../../utils/utils.dart';
import 'referral_bloc.dart';
import 'referral_dl.dart';
import 'referral_shimmer.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  ReferralBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= ReferralBloc(context);
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
        title: Text(languages.referHistory, style: toolbarStyle(context: context)),
      ),
      body: StreamBuilder<ApiResponse<ReferralModel>>(
        stream: _bloc?.subject,
        builder: (context, snapReferral) {
          List<ReferralListItem> referralList = snapReferral.data?.data?.referInfoList ?? [];
          return switch (snapReferral.data?.status ?? Status.loading) {
            Status.loading => ReferralShimmer(),
            Status.completed => _referralListWidget(referralList, snapReferral.data?.data?.usedInfo),
            Status.error => NoRecordFound(),
          };
        },
      ),
    );
  }

  Widget _referralListWidget(List<ReferralListItem> referralList, UsedInfo? usedInfo) {
    return (referralList.isEmpty && usedInfo == null)
        ? NoRecordFound(message: languages.noRecordFound)
        : SingleChildScrollView(
          child: Column(
            children: [
              (usedInfo != null) ? _itemUsedInfo(usedInfo) : Container(),
              ListView.separated(
                itemCount: referralList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
                separatorBuilder: (context, index) {
                  return Divider(color: getCurrentTheme(context).colorDivider);
                },
                itemBuilder: (context, index) {
                  ReferralListItem referralListItem = referralList[index];
                  return _itemReferralList(referralListItem);
                },
              ),
            ],
          ),
        );
  }

  Widget _itemUsedInfo(UsedInfo? usedInfo) {
    return Container(
      padding: EdgeInsetsDirectional.all(10.sp),
      margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 30.sp, bottom: 20.sp),
      decoration: BoxDecoration(
        border: Border.all(color: getCurrentTheme(context).colorPrimary, width: 0.5.w),
        borderRadius: BorderRadius.circular(15.r),
        color: getCurrentTheme(context).colorSelectionPrimaryOpc,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(15.sp),
            decoration: BoxDecoration(color: getCurrentTheme(context).colorPrimary, borderRadius: BorderRadius.circular(15.r)),
            child: Icon(CustomIcons.verifiedUser, color: getCurrentTheme(context).colorWhite, size: 25.sp),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(usedInfo?.name ?? "", style: bodyText(context: context, fontWeight: FontWeight.w600)),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(CustomIcons.discountPercent, color: getCurrentTheme(context).colorIconCommon, size: 16.sp),
                  SizedBox(width: 5.w),
                  Text(usedInfo?.userDiscountType == 1 ? languages.amount : languages.percentage, style: bodyText(context: context, fontSize: textSize14px)),
                  SizedBox(width: 8.w),
                  Container(height: 4.sp, width: 4.sp, decoration: BoxDecoration(shape: BoxShape.circle, color: getCurrentTheme(context).colorIconCommon)),
                  SizedBox(width: 8.w),
                  Text(
                    usedInfo?.userDiscountType == 1 ? getAmountWithCurrency(usedInfo?.userDiscount ?? 0) : "${usedInfo?.userDiscount}%",
                    style: bodyText(context: context, fontSize: textSize14px),
                  ),
                  SizedBox(width: 8.w),
                  Container(height: 4.sp, width: 4.sp, decoration: BoxDecoration(shape: BoxShape.circle, color: getCurrentTheme(context).colorIconCommon)),
                  SizedBox(width: 8.w),
                  Text((usedInfo?.userStatus ?? 0) == 1 ? languages.claimed : languages.pending, style: bodyText(context: context, fontSize: textSize14px)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemReferralList(ReferralListItem referralListItem) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(vertical: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadImageWithPlaceHolder(
            width: 70.sp,
            height: 70.sp,
            image: referralListItem.profileImage ?? "",
            defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
            borderRadius: BorderRadius.circular(15.r),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(referralListItem.name ?? "", style: bodyText(context: context, fontWeight: FontWeight.w600)),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(CustomIcons.discountPercent, color: getCurrentTheme(context).colorIconCommon, size: 16.sp),
                      SizedBox(width: 5.w),
                      Text(
                        referralListItem.referDiscountType == 1 ? languages.amount : languages.percentage,
                        style: bodyText(context: context, fontSize: textSize14px),
                      ),
                      SizedBox(width: 8.w),
                      Container(height: 4.sp, width: 4.sp, decoration: BoxDecoration(shape: BoxShape.circle, color: getCurrentTheme(context).colorIconCommon)),
                      SizedBox(width: 8.w),
                      Text(
                        referralListItem.referDiscountType == 1
                            ? getAmountWithCurrency(referralListItem.referDiscount ?? "")
                            : "${referralListItem.referDiscount}%",
                        style: bodyText(context: context, fontSize: textSize14px),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ReferralStatusView(referralStatus: referralListItem.referStatus ?? 0),
        ],
      ),
    );
  }
}
