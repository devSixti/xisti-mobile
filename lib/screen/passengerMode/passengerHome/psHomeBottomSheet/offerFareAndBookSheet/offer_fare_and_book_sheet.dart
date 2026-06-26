import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../commonView/customCountryCodePicker/custom_country_code_picker.dart';
import '../../../../../commonView/custom_rounded_button.dart';
import '../../../../../commonView/custom_switch.dart';
import '../../../../../commonView/custom_text_field.dart';
import '../../../../../commonView/dropdown_button2.dart';
import '../../../../../commonView/scaffold_with_safe_area.dart';
import '../../../../../commonView/spinner_date_time_picker.dart';
import '../../../../../hive/hive_helper.dart';
import '../../../../../main.dart';
import '../../../../../utils/destination_payment_util.dart';
import '../../../../../commonView/xisti_bottom_sheet_shell.dart';
import '../../../../../commonView/xisti_horizontal_payment_selector.dart';
import '../../../../../utils/xisti_ui_tokens.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/validator.dart';
import '../../passenger_home_dl.dart';
import 'offer_fare_and_book_bloc.dart';
import 'offer_payment_selection.dart';

class OfferFareAndBookSheet extends StatefulWidget {
  final double recommendedFare, minFare, maxFare;
  final String km, minutes, recipientName, recipientNumber, estimatedPrice, parcelNote;
  final String destinationPaymentMethod, packageWeightKg, packageHeightCm, packageWidthCm, packageLengthCm;
  final bool isCourier;
  final bool isEncomienda;
  final List<DeliveryVehicleOption> deliveryVehicleOptions;
  final String deliveryDisclaimer;
  final int? selectedDeliveryVehicleServiceId;
  final int paymentType, autoAccept;
  final DateTime? scheduleDate;
  final Function(
    String offerFare,
    int paymentType,
    String destinationPaymentMethod,
    DateTime? scheduleDate,
    int autoAccept,
    String recipientName,
    String recipientNumber,
    String estimatedPrice,
    String parcelNote,
    String packageWeightKg,
    String packageHeightCm,
    String packageWidthCm,
    String packageLengthCm,
    int requestedVehicleServiceId,
  )
  onSubmit;

  const OfferFareAndBookSheet({
    super.key,
    required this.isCourier,
    this.isEncomienda = false,
    required this.deliveryVehicleOptions,
    required this.deliveryDisclaimer,
    this.selectedDeliveryVehicleServiceId,
    required this.recommendedFare,
    required this.minFare,
    required this.maxFare,
    required this.km,
    required this.minutes,
    required this.paymentType,
    required this.autoAccept,
    this.scheduleDate,
    required this.recipientName,
    required this.recipientNumber,
    required this.estimatedPrice,
    required this.parcelNote,
    required this.destinationPaymentMethod,
    required this.packageWeightKg,
    required this.packageHeightCm,
    required this.packageWidthCm,
    required this.packageLengthCm,
    required this.onSubmit,
  });

  @override
  State<OfferFareAndBookSheet> createState() => _OfferFareAndBookSheetState();
}

class _OfferFareAndBookSheetState extends State<OfferFareAndBookSheet> {
  OfferFareAndBookBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= OfferFareAndBookBloc(
      context,
      widget.isCourier,
      widget.isEncomienda,
      widget.deliveryVehicleOptions,
      widget.deliveryDisclaimer,
      widget.recommendedFare,
      widget.onSubmit,
      widget.scheduleDate,
      widget.recipientName,
      widget.recipientNumber,
      widget.estimatedPrice,
      widget.parcelNote,
      widget.paymentType,
      widget.autoAccept,
      widget.destinationPaymentMethod,
      widget.packageWeightKg,
      widget.packageHeightCm,
      widget.packageWidthCm,
      widget.packageLengthCm,
      widget.selectedDeliveryVehicleServiceId,
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
      resizeToAvoidBottomInset: true,
      body: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: XistiBottomSheetShell(
          title: languages.offerAmount,
          onClose: () => Navigator.pop(context),
          children: [
            Form(
              key: _bloc?.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  offerFare(),
                  Divider(height: 0, thickness: 2.h, color: getCurrentTheme(context).colorTextFieldBorder),
                  fareInfo(),
                  offerPaymentMethod(),
                  if (widget.isCourier || widget.isEncomienda) ...[
                    deliveryLegalNoticeCompact(),
                    if (widget.deliveryVehicleOptions.isNotEmpty) deliveryVehicleSection(),
                    if (widget.deliveryDisclaimer.isNotEmpty) deliveryDisclaimerBanner(),
                    recipientName(),
                    recipientNumber(),
                    if (widget.isEncomienda) ...[
                      parcelNote(),
                      encomiendaPriceCap(),
                    ] else ...[
                      estimatedPrice(),
                      packageDimensions(),
                      parcelNote(),
                    ],
                  ],
                  autoAcceptView(),
                  CustomRoundedButton(context, languages.findDrive, () {
                    if (_bloc?.formKey.currentState!.validate() ?? false) {
                      _bloc?.onSubmitValue();
                    }
                  }, margin: EdgeInsetsDirectional.only(top: 20.h)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget deliveryLegalNoticeCompact() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 12.h),
      child: Text(
        languages.deliveryLegalNotice,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: bodyText(context: context, fontSize: textSize10px, textColor: getCurrentTheme(context).colorTextLight),
      ),
    );
  }

  Widget deliveryDisclaimerBanner() {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(top: 12.h),
      padding: EdgeInsetsDirectional.all(12.w),
      decoration: BoxDecoration(
        color: XistiBrand.legalOrangeBg,
        borderRadius: BorderRadius.circular(XistiUiTokens.cardRadius),
        border: Border.all(color: XistiBrand.legalOrange.withValues(alpha: 0.35)),
      ),
      child: Text(
        widget.deliveryDisclaimer,
        style: bodyText(context: context, fontSize: textSize12px, textColor: XistiBrand.legalOrange),
      ),
    );
  }

  Widget deliveryVehicleSection() {
    if (widget.deliveryVehicleOptions.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: EdgeInsetsDirectional.only(top: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isEncomienda ? languages.vehicleForErrand : languages.transportMediumForDelivery,
            style: bodyText(context: context, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10.h),
          StreamBuilder<int?>(
            stream: _bloc?.selectedDeliveryVehicleServiceIdSubject,
            builder: (context, snap) {
              final selectedId = snap.data;
              return Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: widget.deliveryVehicleOptions.map((option) {
                  final id = option.vehicleServiceId ?? 0;
                  final isSelected = selectedId == id &&
                      (option.deliveryVariant == null ||
                          widget.deliveryVehicleOptions.where((o) => o.vehicleServiceId == id).length == 1);
                  return GestureDetector(
                    onTap: () => _bloc?.selectDeliveryVehicle(id),
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? getCurrentTheme(context).colorPrimary.withValues(alpha: 0.12)
                            : getCurrentTheme(context).colorScaffoldBg,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? getCurrentTheme(context).colorPrimary
                              : getCurrentTheme(context).colorTextFieldBorder,
                        ),
                      ),
                      child: Text(
                        option.label ?? '',
                        style: bodyText(
                          context: context,
                          fontSize: textSize13px,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Container parcelNote() {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 20.h),
      decoration: BoxDecoration(
        border: Border.all(color: getCurrentTheme(context).colorTextFieldBorder, width: 1.sp),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsetsDirectional.only(start: 15.w, top: 10.h, bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CustomIcons.description, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
          Expanded(
            child: TextFormFieldCustom(
              controller: _bloc?.noteController,
              maxLine: 5,
              minLine: 3,
              keyboardType: TextInputType.multiline,
              backgroundColor: Colors.transparent,
              setError: true,
              validator: (value) {
                return validateEmptyField(value, languages.enterParcelNote);
              },
              contentPadding: EdgeInsetsDirectional.only(start: 10.w),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding estimatedPrice() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 20.h),
      child: TextFormFieldCustom(
        controller: _bloc?.estimatedPriceController,
        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
          TextInputFormatter.withFunction((oldValue, newValue) {
            final text = newValue.text;
            return text.isEmpty
                ? newValue
                : double.tryParse(text) == null
                ? oldValue
                : newValue;
          }),
        ],
        hint: languages.parcelEstimatedPrice,
        commonPrefixIcon: CustomIcons.paymentMethod,
      ),
    );
  }

  Padding encomiendaPriceCap() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 12.h),
      child: TextFormFieldCustom(
        controller: _bloc?.estimatedPriceController,
        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        hint: languages.priceCapHint,
        setError: true,
        validator: (value) => validateEmptyField(value, languages.indicatePriceCap),
        commonPrefixIcon: CustomIcons.paymentMethod,
      ),
    );
  }

  Padding recipientNumber() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 20.h),
      child: TextFormFieldCustom(
        setError: true,
        keyboardType: TextInputType.phone,
        controller: _bloc?.recipientNumberController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        hint: languages.contactNumber,
        prefix: CustomCountryCodePicker(
          showDropDownButton: true,
          flagWidth: 35.w,
          padding: const EdgeInsets.all(0),
          textStyle: bodyText(context: context, fontWeight: FontWeight.w500),
          dialogTextStyle: bodyText(context: context, fontWeight: FontWeight.w500),
          onChanged: (countryCode) {
            _bloc?.countryCodeController.sink.add(countryCode);
          },
          onInit: (countryCode) {
            _bloc?.countryCodeController.sink.add(countryCode!);
          },
          initialSelection: defaultCountryCode.dialCode,
          builder: (countryCode) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 10.w),
                  child: Icon(CustomIcons.call, color: getCurrentTheme(context).colorIconCommon, size: 20.sp),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 10.w),
                  child: Text(countryCode?.dialCode ?? "", style: bodyText(context: context, fontWeight: FontWeight.w500)),
                ),
                Padding(padding: EdgeInsetsDirectional.only(start: 5.w), child: Icon(Icons.arrow_drop_down, color: Colors.grey, size: 25.sp)),
              ],
            );
          },
        ),
        textAlignVertical: TextAlignVertical.center,
        validator: (value) {
          return colombiaMobileNumberValidate(value);
        },
      ),
    );
  }

  Padding recipientName() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 20.h),
      child: TextFormFieldCustom(
        controller: _bloc?.recipientNameController,
        keyboardType: TextInputType.text,
        hint: languages.recipientName,
        setError: true,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
        ],
        validator: (value) {
          return registerFullNameValidate(value, languages.enterRecipientName);
        },
        commonPrefixIcon: CustomIcons.name,
      ),
    );
  }

  Container fareInfo() {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 10.h),
      padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.w, bottom: 10.w),
      decoration: BoxDecoration(
        color: getCurrentTheme(context).colorSelectionPrimaryOpc,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: getCurrentTheme(context).colorPrimary, width: 0.5.sp),
      ),
      child: Text(
        "${languages.recommendedFare} ${getAmountWithCurrency(widget.recommendedFare)}, ${languages.minFare} ${getAmountWithCurrency(widget.minFare)}, ${languages.maxFare} ${getAmountWithCurrency(widget.maxFare)}, ${widget.km}, ${widget.minutes}",
        style: bodyText(context: context, fontWeight: FontWeight.w500, fontSize: textSize14px),
      ),
    );
  }

  Container autoAcceptView() {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 20.h),
      child: Row(
        children: [
          Expanded(child: Text(languages.autoAcceptDriverRide, style: bodyText(context: context, fontWeight: FontWeight.w500))),
          StreamBuilder<bool>(
            stream: _bloc?.autoAcceptController,
            builder: (context, snapAutoAccept) {
              bool autoAccept = snapAutoAccept.data ?? false;
              return CustomSwitch(
                width: 35.w,
                radius: 32.r,
                activeColor: getCurrentTheme(context).colorPrimary,
                disableColor: getCurrentTheme(context).colorIconLight,
                thumbColor: getCurrentTheme(context).colorWhite,
                value: autoAccept,
                innerPadding: EdgeInsets.all(3.sp),
                thumbSize: 15.sp,
                onChanged: (value) {
                  _bloc?.autoAcceptController.sink.add(value);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget scheduleRide() {
    DateTime dateTime = DateTime.now().add(Duration(hours: 1));
    if (widget.scheduleDate != null) {
      if (widget.scheduleDate!.isAfter(dateTime)) {
        dateTime = widget.scheduleDate!;
      } else {
        _bloc?.showScheduleController.sink.add(false);
        _bloc?.scheduleDateTimeController.sink.add(null);
      }
      // dateTime = DateTime.parse(widget.scheduleDate);
    }

    return StreamBuilder<bool>(
      stream: _bloc?.showScheduleController,
      builder: (context, snapShow) {
        bool showSchedule = snapShow.data ?? false;
        DateTime minimumDate = DateTime.now().add(Duration(hours: 1));
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                _bloc?.showScheduleController.sink.add(true);
                _bloc?.scheduleDateTimeController.sink.add(minimumDate);
              },
              child: Container(
                margin: EdgeInsetsDirectional.only(top: 20.h),
                padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 12.h, bottom: 12.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: getCurrentTheme(context).colorTextFieldBorder, width: 1.w),
                ),
                child: StreamBuilder<DateTime?>(
                  stream: _bloc?.scheduleDateTimeController,
                  builder: (context, snapDate) {
                    String date = "";
                    if (snapDate.data != null) {
                      date = getDateTimeWithoutTimezoneFromObj(snapDate.data!);
                    }

                    return Row(
                      children: [
                        Icon(CustomIcons.scheduleRide, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
                        Expanded(
                          child: Container(
                            margin: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
                            child: Text(
                              date.isEmpty ? languages.scheduleRide : date,
                              style: bodyText(
                                context: context,
                                fontWeight: FontWeight.w500,
                                textColor: date.isNotEmpty ? getCurrentTheme(context).colorTextCommon : getCurrentTheme(context).colorTextLight,
                              ),
                            ),
                          ),
                        ),
                        if (date.isNotEmpty || showSchedule)
                          GestureDetector(
                            onTap: () {
                              _bloc?.showScheduleController.sink.add(false);
                              _bloc?.scheduleDateTimeController.sink.add(null);
                            },
                            child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            if (showSchedule)
              Container(
                margin: EdgeInsetsDirectional.only(top: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: getCurrentTheme(context).colorBorder, width: 1.w),
                ),
                child: SpinnerDateTimePicker(
                  use24hFormat: false,
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: dateTime,
                  minimumDate: minimumDate,
                  maximumDate: DateTime.now().add(Duration(days: 5)),
                  didSetTime: (DateTime datetime) {
                    _bloc?.scheduleDateTimeController.sink.add(datetime);
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget offerPaymentMethod() {
    return StreamBuilder<List<OfferPaymentSelection>>(
      stream: _bloc?.courierPaymentListController,
      builder: (context, snapList) {
        final paymentList = snapList.data ?? [];
        if (paymentList.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsetsDirectional.only(top: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                languages.paymentMethod,
                style: bodyText(context: context, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10.h),
              StreamBuilder<OfferPaymentSelection?>(
                stream: _bloc?.selectedCourierPaymentController,
                builder: (context, snapPayment) {
                  return XistiHorizontalPaymentSelector<OfferPaymentSelection>(
                    options: paymentList,
                    selected: snapPayment.data ?? paymentList.first,
                    onSelected: (value) => _bloc?.applyCourierPaymentSelection(value),
                    labelOf: (e) => e.label,
                    paymentTypeOf: (e) => e.paymentType,
                    destinationCodeOf: (e) => e.destinationPaymentCode,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget destinationPaymentMethod() {
    return StreamBuilder<List<DestinationPaymentOption>>(
      stream: _bloc?.destinationPaymentListController,
      builder: (context, snapList) {
        final options = snapList.data ?? [];
        return Container(
          height: 50.h,
          alignment: AlignmentDirectional.center,
          margin: EdgeInsetsDirectional.only(top: 20.h),
          decoration: BoxDecoration(
            color: getCurrentTheme(context).colorScaffoldBg,
            border: Border.all(color: getCurrentTheme(context).colorTextFieldBorder, width: 1.sp),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: options.isEmpty
              ? const SizedBox.shrink()
              : StreamBuilder<DestinationPaymentOption?>(
                  stream: _bloc?.selectedDestinationPaymentController,
                  builder: (context, snapSelected) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2<DestinationPaymentOption>(
                        isExpanded: true,
                        value: snapSelected.data ?? options.first,
                        onChanged: (value) {
                          if (value != null) {
                            _bloc?.selectedDestinationPaymentController.sink.add(value);
                          }
                        },
                        items: options
                            .map((e) => DropdownItem(value: e, child: Text(e.label, style: bodyText(context: context))))
                            .toList(),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget packageDimensions() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(top: 20.h),
          child: TextFormFieldCustom(
            controller: _bloc?.packageWeightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hint: languages.packageWeightHint,
            setError: true,
            validator: (v) => validateEmptyField(v, languages.enterPackageWeight),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(top: 12.h),
          child: Row(
            children: [
              Expanded(
                child: TextFormFieldCustom(
                  controller: _bloc?.packageHeightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  hint: languages.packageHeightHint,
                  setError: true,
                  validator: (v) => validateEmptyField(v, languages.packageHeightHint),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: TextFormFieldCustom(
                  controller: _bloc?.packageWidthController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  hint: languages.packageWidthHint,
                  setError: true,
                  validator: (v) => validateEmptyField(v, languages.packageWidthHint),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: TextFormFieldCustom(
                  controller: _bloc?.packageLengthController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  hint: languages.packageLengthHint,
                  setError: true,
                  validator: (v) => validateEmptyField(v, languages.packageLengthHint),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget paymentType() {
    return StreamBuilder<List<PaymentTypeModel>>(
      stream: _bloc?.paymentListController,
      builder: (context, snapList) {
        List<PaymentTypeModel> paymentList = snapList.data ?? [];
        return Container(
          height: 50.h,
          alignment: AlignmentDirectional.center,
          margin: EdgeInsetsDirectional.only(top: 20.h),
          decoration: BoxDecoration(
            color: getCurrentTheme(context).colorScaffoldBg,
            border: Border.all(color: getCurrentTheme(context).colorTextFieldBorder, width: 1.sp),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child:
              paymentList.isNotEmpty
                  ? StreamBuilder<PaymentTypeModel?>(
                    stream: _bloc?.selectedPaymentController,
                    builder: (context, snapPayment) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton2<PaymentTypeModel>(
                          isExpanded: true,
                          dropdownStyleData: DropdownStyleData(
                            padding: EdgeInsetsDirectional.zero,
                            decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: BorderRadius.all(Radius.circular(20.r))),
                          ),
                          buttonStyleData: ButtonStyleData(
                            padding: EdgeInsetsDirectional.zero,
                            overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: getCurrentTheme(context).colorScaffoldBg),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Container(
                              margin: EdgeInsetsDirectional.only(end: 10.w),
                              child: Icon(CustomIcons.arrowDown, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                            ),
                          ),
                          alignment: Alignment.center,
                          value: snapPayment.data ?? paymentList.first,
                          underline: Container(),
                          isDense: false,
                          onChanged: (value) {
                            if (value != null) {
                              _bloc?.selectedPaymentController.sink.add(value);
                            }
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return paymentList.map<Widget>((PaymentTypeModel value) {
                              return Container(
                                padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w),
                                child: Row(
                                  children: [
                                    Icon(getPaymentTypeIcon(snapPayment.data?.type ?? 0), size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                                    SizedBox(width: 10.w),
                                    Text(
                                      snapPayment.data?.name ?? "",
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: bodyText(context: context, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }).toList();
                          },
                          items:
                              paymentList.map<DropdownItem<PaymentTypeModel>>((PaymentTypeModel e) {
                                return DropdownItem<PaymentTypeModel>(
                                  value: e,
                                  child: Container(
                                    padding: EdgeInsetsDirectional.only(start: 5.w, end: 15.w),
                                    child: Row(
                                      children: [
                                        Icon(getPaymentTypeIcon(e.type ?? 0), size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                                        SizedBox(width: 10.w),
                                        Text(
                                          e.name ?? "",
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: bodyText(context: context, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      );
                    },
                  )
                  : Container(),
        );
      },
    );
  }

  Widget offerFare() {
    return Container(
      color: getCurrentTheme(context).colorTextFieldBg,
      alignment: AlignmentDirectional.center,
      child: IntrinsicWidth(
        child: TextFormFieldCustom(
          controller: _bloc?.offerFareController,
          setError: true,
          validator: (value) {
            String val = validateEmptyField(value, languages.enterFareValue);
            if (val.isEmpty) {
              double amount = parseSafeDouble(value);
              if (amount < getDoubleFromDynamic(widget.minFare)) {
                val = languages.offerFareMin(getAmountWithCurrency(widget.minFare));
              } else if (amount > widget.maxFare) {
                val = languages.offerFareMax(getAmountWithCurrency(widget.maxFare));
              }
            }
            return val;
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
          inputFormatters: [getDecimalInputFormatter()],
          style: bodyText(context: context, fontSize: 40.sp, fontWeight: FontWeight.w600),
          contentPadding: EdgeInsetsDirectional.zero,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
          textAlign: TextAlign.center,
          prefix: Container(
            margin: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
            child: Text(
              getStringFromSettingBox(hiveSelectedCurrency, defaultValue: defaultCurrency),
              style: bodyText(context: context, fontSize: 40.sp, fontWeight: FontWeight.w600),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
