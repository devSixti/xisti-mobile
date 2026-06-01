import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/custom_text_field.dart';
import '../../../networking/api_response.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import '../../../utils/validator.dart';
import 'bank_detail_dl.dart';
import 'bank_details_bloc.dart';
import 'bank_details_shimmer.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  BankDetailsBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= BankDetailsBloc(context);
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
        title: Text(languages.bankDetails, style: toolbarStyle(context: context)),
      ),
      body: StreamBuilder<ApiResponse<BankDetailPojo>>(
        stream: _bloc?.subject,
        builder: (context, snapBankDetail) {
          return switch (snapBankDetail.data?.status ?? Status.loading) {
            Status.loading => BankDetailsShimmer(),
            Status.completed => _bankDetailForm(),
            Status.error => _bankDetailForm(),
          };
        },
      ),
    );
  }

  Widget _bankDetailForm() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _bloc?.formKey,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 30.sp, start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 80.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormFieldCustom(
                    controller: _bloc?.accountNumberTEC,
                    hint: languages.accountNumber,
                    commonPrefixIcon: CustomIcons.referralCode,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    suffix: Padding(
                      padding: EdgeInsetsDirectional.only(end: 15.w),
                      child: Icon(CustomIcons.edit, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
                    ),
                    setError: true,
                    validator: (value) {
                      return validateEmptyField(value, languages.enterAccountNumber);
                    },
                  ),
                  SizedBox(height: 20.sp),
                  TextFormFieldCustom(
                    controller: _bloc?.accountHolderNameTEC,
                    hint: languages.accountHolderName,
                    commonPrefixIcon: CustomIcons.name,
                    suffix: Padding(
                      padding: EdgeInsetsDirectional.only(end: 15.w),
                      child: Icon(CustomIcons.edit, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
                    ),
                    setError: true,
                    validator: (value) {
                      return validateEmptyField(value, languages.enterAccountHolderName);
                    },
                  ),
                  SizedBox(height: 20.sp),
                  TextFormFieldCustom(
                    controller: _bloc?.bankNameTEC,
                    hint: languages.bankName,
                    commonPrefixIcon: CustomIcons.bankName,
                    suffix: Padding(
                      padding: EdgeInsetsDirectional.only(end: 15.w),
                      child: Icon(CustomIcons.edit, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
                    ),
                    setError: true,
                    validator: (value) {
                      return validateEmptyField(value, languages.enterBankName);
                    },
                  ),
                  SizedBox(height: 20.sp),
                  TextFormFieldCustom(
                    controller: _bloc?.bankLocationTEC,
                    hint: languages.bankLocation,
                    commonPrefixIcon: CustomIcons.otherAddress,
                    suffix: Padding(
                      padding: EdgeInsetsDirectional.only(end: 15.w),
                      child: Icon(CustomIcons.edit, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
                    ),
                    setError: true,
                    validator: (value) {
                      return validateEmptyField(value, languages.enterBankLocation);
                    },
                  ),
                  SizedBox(height: 20.sp),
                  TextFormFieldCustom(
                    controller: _bloc?.paymentEmailTEC,
                    hint: languages.emailAddress,
                    commonPrefixIcon: CustomIcons.email,
                    suffix: Padding(
                      padding: EdgeInsetsDirectional.only(end: 15.w),
                      child: Icon(CustomIcons.edit, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
                    ),
                    setError: true,
                    validator: (value) {
                      return emailValidate(value);
                    },
                  ),
                  SizedBox(height: 20.sp),
                  TextFormFieldCustom(
                    controller: _bloc?.swiftCodeTEC,
                    hint: languages.swiftCode,
                    commonPrefixIcon: CustomIcons.referralCode,
                    suffix: Padding(
                      padding: EdgeInsetsDirectional.only(end: 15.w),
                      child: Icon(CustomIcons.edit, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
                    ),
                    setError: true,
                    validator: (value) {
                      return validateEmptyField(value, languages.enterSwiftCode);
                    },
                  ),
                  SizedBox(height: 20.sp),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: StreamBuilder<ApiResponse<BaseModel>>(
            stream: _bloc?.updateSubject,
            builder: (context, snapLoading) {
              var isLoading = snapLoading.hasData && snapLoading.data?.status == Status.loading;

              return CustomRoundedButton(
                context,
                languages.update,
                isLoading
                    ? null
                    : () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_bloc?.formKey.currentState?.validate() ?? false) {
                          _bloc?.callUpdateBankDetailApi();
                        }
                      },
                setProgress: isLoading,
                margin: EdgeInsetsDirectional.symmetric(vertical: getBottomMargin(), horizontal: commonHorizontalPadding),
              );
            },
          ),
        ),
      ],
    );
  }
}
