import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonView/common_view.dart';
import '../../../../commonView/custom_rounded_button.dart';
import '../../../../commonView/custom_text_field.dart';
import '../../../../networking/api_response.dart';
import '../../../../networking/base_dl.dart';
import '../../../../utils/utils.dart';
import 'wallet_cash_out_bloc.dart';

class WalletCaseOut extends StatefulWidget {
  final double walletAmount;

  const WalletCaseOut({super.key, required this.walletAmount});

  @override
  State<WalletCaseOut> createState() => _WalletCaseOutState();
}

class _WalletCaseOutState extends State<WalletCaseOut> {
  WalletCaseOutBloc? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc ??= WalletCaseOutBloc(context, widget.walletAmount);
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
        title: Text(languages.cashOut, style: toolbarStyle(context: context)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsetsDirectional.symmetric(vertical: 20.h, horizontal: commonHorizontalPadding),
            child: Column(
              spacing: 20.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(languages.cashOut, style: bodyText(context: context, fontSize: textSize22px, fontWeight: FontWeight.w600)), cashOutAmount()],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: StreamBuilder<ApiResponse<BaseModel>>(
              stream: _bloc?.cashOutSubject,
              builder: (context, cashOutSnap) {
                final isLoading = cashOutSnap.data?.status == Status.loading;
                return CustomRoundedButton(
                  context,
                  languages.requestToCash,
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

  Widget cashOutAmount() {
    return TextFormFieldCustom(
      controller: _bloc?.amountTEC,
      setClear: true,
      commonPrefixIcon: CustomIcons.paymentMethod,
      decoration: InputDecoration(labelText: languages.cashOutAmount),
      textInputAction: TextInputAction.done,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
      inputFormatters: [getDecimalInputFormatter(decimalRange: 3)],
      validator: (value) {
        return "";
      },
    );
  }
}
