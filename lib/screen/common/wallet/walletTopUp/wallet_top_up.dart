import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonView/common_view.dart';
import '../../../../commonView/custom_rounded_button.dart';
import '../../../../commonView/custom_text_field.dart';
import '../../../../networking/api_response.dart';
import '../../../../utils/utils.dart';
import '../walletHome/wallet_home_dl.dart';
import 'wallet_top_up_bloc.dart';

class WalletTopUp extends StatefulWidget {
  final List<TopupWallet> walletTopUpOptionList;
  final double minTopupAmount;

  const WalletTopUp({super.key, required this.walletTopUpOptionList, this.minTopupAmount = 13000});

  @override
  State<WalletTopUp> createState() => _WalletTopUpState();
}

class _WalletTopUpState extends State<WalletTopUp> {
  WalletTopUpBloc? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc ??= WalletTopUpBloc(context, widget.walletTopUpOptionList, minTopupAmount: widget.minTopupAmount);
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
        title: Text(languages.topUp, style: toolbarStyle(context: context)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsetsDirectional.symmetric(vertical: 20.h, horizontal: commonHorizontalPadding),
            child: Column(spacing: 20.h, crossAxisAlignment: CrossAxisAlignment.start, children: [topUpAmount(), minTopupNotice(), customAmount()]),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: StreamBuilder<ApiResponse<WalletBalancePojo>>(
              stream: _bloc?.addAmountToWalletSubject,

              builder: (context, addAmountSnap) {
                final isLoading = addAmountSnap.data?.status == Status.loading;
                return CustomRoundedButton(
                  context,
                  languages.proceedToAddMoney,
                  isLoading
                      ? null
                      : () {
                        _bloc?.validateAndGo();
                      },
                  setProgress: isLoading,
                  minWidth: double.maxFinite,
                  margin: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding, vertical: getBottomMargin()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget topUpAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(languages.chooseAmount, style: bodyText(context: context, fontSize: textSize22px, fontWeight: FontWeight.w600)),

        if (widget.walletTopUpOptionList.isNotEmpty) ...[
          SizedBox(height: 20.h),
          StreamBuilder<int>(
            stream: _bloc?.selectedTopUpOptionSubject,
            builder: (context, snapSelected) {
              int selectedId = snapSelected.data ?? 0;
              return GridView.builder(
                shrinkWrap: true,
                itemCount: widget.walletTopUpOptionList.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.3,
                  crossAxisSpacing: 15.sp,
                  mainAxisSpacing: 15.sp,
                ),
                itemBuilder: (context, index) {
                  TopupWallet itemTopUp = widget.walletTopUpOptionList[index];
                  final isSelected = itemTopUp.id == selectedId;

                  return GestureDetector(
                    onTap: () {
                      _bloc?.selectedTopUpOptionSubject.sink.add(itemTopUp.id ?? 0);
                      _bloc?.amountTEC.clear();
                    },
                    child: Container(
                      margin: EdgeInsetsDirectional.symmetric(vertical: 1.h),
                      padding: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: isSelected ? getCurrentTheme(context).colorPrimary : Colors.transparent,
                        border: Border.all(color: isSelected ? Colors.transparent : getCurrentTheme(context).colorTextFieldBorder, width: 0.5.sp),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              getAmountWithCurrency(itemTopUp.packagePrice),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: bodyText(
                                context: context,
                                fontSize: textSize14px,
                                fontWeight: FontWeight.w600,
                                textColor: isSelected ? getCurrentTheme(context).colorWhite : getCurrentTheme(context).colorTextCommon,
                              ),
                            ),
                          ),
                          if (isSelected) ...[
                            SizedBox(width: 10.w),
                            GestureDetector(
                              onTap: () {
                                _bloc?.selectedTopUpOptionSubject.sink.add(0);
                                _bloc?.amountTEC.clear();
                              },
                              child: Icon(CustomIcons.removeFilled, color: getCurrentTheme(context).colorWhite, size: 15.sp),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ],
    );
  }

  Widget minTopupNotice() {
    return Text(
      languages.walletMinTopupNotice,
      style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w500),
    );
  }

  Widget customAmount() {
    return TextFormFieldCustom(
      controller: _bloc?.amountTEC,
      setClear: true,
      commonPrefixIcon: CustomIcons.paymentMethod,
      decoration: InputDecoration(labelText: languages.enterAmount),
      textInputAction: TextInputAction.done,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
      inputFormatters: [getDecimalInputFormatter()],
      validator: (value) {
        return "";
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          _bloc?.selectedTopUpOptionSubject.sink.add(0);
        }
      },
    );
  }
}
