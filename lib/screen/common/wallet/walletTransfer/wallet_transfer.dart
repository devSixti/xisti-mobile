import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonView/common_view.dart';
import '../../../../commonView/custom_rounded_button.dart';
import '../../../../commonView/custom_text_field.dart';
import '../../../../networking/api_response.dart';
import '../../../../networking/base_dl.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/validator.dart';
import 'searchUser/search_user.dart';
import 'wallet_transfer_bloc.dart';

class WalletTransfer extends StatefulWidget {
  final double walletAmount;

  const WalletTransfer({super.key, required this.walletAmount});

  @override
  State<WalletTransfer> createState() => _WalletTransferState();
}

class _WalletTransferState extends State<WalletTransfer> {
  WalletTransferBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= WalletTransferBloc(context, widget.walletAmount);
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
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        Navigator.pop(context, _bloc?.walletAmount);
      },
      child: ScaffoldWithSafeArea(
        resizeToAvoidBottomInset: true,
        appBar: CommonAppBar(
          centerTitle: true,
          leading: backButtonForAppBarCustom(
            context: context,
            onBackPress: () {
              Navigator.pop(context);
            },
          ),
          title: Text(languages.transfer, style: toolbarStyle(context: context)),
        ),
        body: _buildWalletTransfer(context),
      ),
    );
  }

  Widget _buildWalletTransfer(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding, vertical: getBottomMargin()),
      child: Column(
        children: [
          walletAmount(),
          SizedBox(height: 20.h),
          Expanded(
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverToBoxAdapter(child: formView()),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Align(alignment: AlignmentDirectional.bottomCenter, child: transferButton()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget walletAmount() {
    return Container(
      constraints: BoxConstraints.expand(height: 151.h, width: double.maxFinite),
      padding: EdgeInsetsDirectional.all(15.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            getCurrentTheme(context).colorPrimary,
            getCurrentTheme(context).colorPrimary,
            getCurrentTheme(context).colorPrimary,
            getCurrentTheme(context).colorWalletBgGradient1,
            getCurrentTheme(context).colorWalletBgGradient2,
            getCurrentTheme(context).colorWalletBgGradient1,
            getCurrentTheme(context).colorPrimary,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: getCurrentTheme(context).colorScaffoldBg),
            child: Icon(CustomIcons.wallet, color: getCurrentTheme(context).colorIconCommon, size: 20.sp),
          ),

          SizedBox(height: 10.h),
          Text(
            languages.currentBalance,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: bodyText(context: context, fontSize: textSize14px, textColor: getCurrentTheme(context).colorTextFieldBg),
          ),

          SizedBox(height: 5.h),
          StreamBuilder<ApiResponse<BaseModel>>(
            stream: _bloc?.transferToWalletSubject,
            builder: (context, snapLoading) {
              return Text(
                getAmountWithCurrency(_bloc?.walletAmount ?? 0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: bodyText(
                  context: context,
                  textColor: getCurrentTheme(context).colorTextFieldBg,
                  fontSize: textSize28px,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget formView() {
    return Form(
      key: _bloc?.formKey,
      child: Column(
        spacing: 20.h,
        children: [
          InkWell(
            onTap: () {
              _bloc?.searchUserTEC.text = "";
              _bloc?.searchUserSubject.add(null);
              openScreenWithResult(context, SearchUser(bloc: _bloc!)).then((value) {
                // TransferUserList transferUserList = value as TransferUserList;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(width: 1.w, color: getCurrentTheme(context).colorTextFieldBorder),
                color: Colors.transparent,
              ),
              padding: EdgeInsetsDirectional.symmetric(horizontal: 12.sp, vertical: 10.sp),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 10.w),
                    child: Icon(CustomIcons.search, color: getCurrentTheme(context).colorIconCommon, size: 24.sp),
                  ),
                  Expanded(
                    child: Hero(
                      tag: "SearchUser",
                      child: Text(
                        languages.searchByContactOrEmail,
                        style: bodyText(
                          context: context,
                          fontSize: textSize16px,
                          textColor: getCurrentTheme(context).colorTextLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          TextFormFieldCustom(
            setError: true,
            readOnly: true,
            decoration: InputDecoration(labelText: languages.beneficial),
            keyboardType: TextInputType.text,
            commonPrefixIcon: CustomIcons.name,
            controller: _bloc?.textBeneficialNameTEC,
          ),

          TextFormFieldCustom(
            setError: true,
            readOnly: true,
            decoration: InputDecoration(labelText: languages.beneficialContactNumber),
            keyboardType: TextInputType.number,
            commonPrefixIcon: CustomIcons.call,
            controller: _bloc?.textNumberTEC,
          ),

          TextFormFieldCustom(
            setError: true,
            readOnly: true,
            decoration: InputDecoration(labelText: languages.beneficialEmail),
            keyboardType: TextInputType.text,
            commonPrefixIcon: CustomIcons.email,
            controller: _bloc?.textEmailTEC,
          ),

          StreamBuilder<bool>(
            stream: _bloc?.showError,
            builder: (context, snapShowError) {
              bool doError = snapShowError.data ?? false;
              return TextFormFieldCustom(
                setError: doError,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                inputFormatters: [getDecimalInputFormatter()],
                decoration: InputDecoration(labelText: languages.amountToTransfer),
                textInputAction: TextInputAction.done,
                commonPrefixIcon: CustomIcons.paymentMethod,
                controller: _bloc?.textAmountTEC,
                validator: (value) {
                  String val = validateEmptyField(value, languages.enterAmount);
                  if (val.isEmpty) {
                    double amount = parseSafeDouble(value);
                    if (amount > (_bloc?.walletAmount ?? 0)) {
                      val = "${languages.youCantTransfer} ${getAmountWithCurrency(_bloc?.walletAmount ?? 0)}";
                    } else if (amount <= 0) {
                      val = languages.invalidAmountMsg;
                    }
                  }
                  return val;
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget transferButton() {
    return StreamBuilder<ApiResponse<BaseModel>>(
      stream: _bloc?.transferToWalletSubject,
      builder: (context, snapLoading) {
        var isLoading = snapLoading.hasData && snapLoading.data?.status == Status.loading;
        return CustomRoundedButton(
          context,
          languages.transfer,
          isLoading
              ? null
              : () {
                  if (_bloc?.formKey.currentState?.validate() ?? false) {
                    if (_bloc?.transferUserList != null) {
                      _bloc?.transferToUserApiCall();
                    } else {
                      openSimpleSnackbar(context, languages.selectUser);
                    }
                  }
                },
          setProgress: isLoading,
          minWidth: double.infinity,
          margin: EdgeInsetsDirectional.only(top: 20.h),
        );
      },
    );
  }
}
