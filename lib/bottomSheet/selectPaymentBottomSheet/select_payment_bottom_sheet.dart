import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../commonView/custom_rounded_button.dart';
import '../../commonView/scaffold_with_safe_area.dart';
import '../../screen/passengerMode/passengerRunningRide/ps_running_ride_dl.dart';
import '../../utils/utils.dart';
import 'select_payment_method_bloc.dart';

class SelectPaymentBottomSheet extends StatefulWidget {
  final double totalPay, walletAmount;
  final bool showCash, showWallet, showOnlinePayment;
  final Function(int paymentType) onSubmit;

  const SelectPaymentBottomSheet({
    super.key,
    required this.totalPay,
    required this.walletAmount,
    required this.showCash,
    required this.showWallet,
    required this.showOnlinePayment,
    required this.onSubmit,
  });

  @override
  State<SelectPaymentBottomSheet> createState() => _SelectPaymentBottomSheetState();
}

class _SelectPaymentBottomSheetState extends State<SelectPaymentBottomSheet> {
  SelectPaymentMethodBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= SelectPaymentMethodBloc(
      context,
      widget.totalPay,
      widget.walletAmount,
      widget.showCash,
      widget.showWallet,
      widget.showOnlinePayment,
      widget.onSubmit,
    );
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
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(child: Container()),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
            padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 25.h, bottom: 20.h),
                        child: Text(
                          languages.payment,
                          textAlign: TextAlign.start,
                          style: bodyText(context: context, fontSize: textSize22px, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                    ),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.52),
                  child: StreamBuilder<List<SelectPaymentMethodItem>>(
                    stream: _bloc?.selectPaymentMethodListController,
                    builder: (context, snapList) {
                      List<SelectPaymentMethodItem> paymentTypeList = snapList.data ?? [];
                      return ListView.separated(
                        itemCount: paymentTypeList.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 20.h);
                        },
                        itemBuilder: (context, index) {
                          SelectPaymentMethodItem paymentItem = paymentTypeList[index];
                          return StreamBuilder<SelectPaymentMethodItem>(
                            stream: _bloc?.selectedPaymentMethodController,
                            builder: (context, snapItem) {
                              SelectPaymentMethodItem? selectedItem = snapItem.data;
                              return GestureDetector(
                                onTap: () {
                                  _bloc?.selectedPaymentMethodController.sink.add(paymentItem);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Icon(
                                        paymentItem.icon,
                                        size: 20.sp,
                                        color:
                                            selectedItem?.id == paymentItem.id
                                                ? getCurrentTheme(context).colorPrimary
                                                : getCurrentTheme(context).colorIconCommon,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
                                          child: RichText(
                                            text: TextSpan(
                                              text: paymentItem.name,
                                              style: bodyText(context: context, fontSize: textSize18px),
                                              children: [
                                                if (paymentItem.secondaryText.isNotEmpty)
                                                  TextSpan(
                                                    text: " ${paymentItem.secondaryText}",
                                                    style: bodyText(
                                                      context: context,
                                                      textColor: getCurrentTheme(context).colorPrimary,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: textSize14px,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 20.sp,
                                        width: 20.sp,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                selectedItem?.id == paymentItem.id
                                                    ? getCurrentTheme(context).colorPrimary
                                                    : getCurrentTheme(context).colorBorder,
                                            width: selectedItem?.id == paymentItem.id ? 5.sp : 1.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                StreamBuilder<SelectPaymentMethodItem>(
                  stream: _bloc?.selectedPaymentMethodController,
                  builder: (context, snapItem) {
                    SelectPaymentMethodItem? selectedItem = snapItem.data;
                    return CustomRoundedButton(
                      context,
                      "${languages.pay} ${getAmountWithCurrency(widget.totalPay)}",
                      (selectedItem?.type ?? 0) == 0
                          ? null
                          : () async {
                            _bloc?.payNow();
                          },
                      minWidth: double.maxFinite,
                      margin: EdgeInsetsDirectional.only(top: 20.h, bottom: getBottomMargin()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
