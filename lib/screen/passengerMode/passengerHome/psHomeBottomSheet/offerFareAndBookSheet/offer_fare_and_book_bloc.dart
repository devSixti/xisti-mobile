import 'package:flutter/cupertino.dart';

import '../../../../../blocs/bloc.dart';
import '../../../../../commonView/customCountryCodePicker/country_code.dart';
import '../../../../../hive/hive_helper.dart';
import '../../../../../utils/destination_payment_util.dart';
import '../../../../../utils/phone_util.dart';
import '../../../../../utils/utils.dart';
import '../../passenger_home_dl.dart';

class OfferFareAndBookBloc extends Bloc {
  BuildContext context;
  final bool isCourier;
  final bool isEncomienda;
  final List<DeliveryVehicleOption> deliveryOptions;
  final String deliveryDisclaimer;
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

  OfferFareAndBookBloc(
    this.context,
    this.isCourier,
    this.isEncomienda,
    this.deliveryOptions,
    this.deliveryDisclaimer,
    double recommendedFare,
    this.onSubmit,
    DateTime? scheduleDate,
    String recipientName,
    String recipientNumber,
    String estimatedPrice,
    String parcelNote,
    int paymentType,
    int autoAccept,
    String destinationPaymentMethod,
    String packageWeightKg,
    String packageHeightCm,
    String packageWidthCm,
    String packageLengthCm,
    int? selectedDeliveryVehicleServiceId,
  ) {
    setPaymentTypeList(paymentType);
    setDestinationPaymentList(destinationPaymentMethod);
    if (deliveryOptions.isNotEmpty) {
      final initial = selectedDeliveryVehicleServiceId ?? deliveryOptions.first.vehicleServiceId ?? 0;
      selectedDeliveryVehicleServiceIdSubject.add(initial > 0 ? initial : null);
    }
    offerFareController.text = getEditableAmount(recommendedFare);
    if (scheduleDate != null) {
      showScheduleController.sink.add(true);
      scheduleDateTimeController.sink.add(scheduleDate);
    }
    if (recipientName.isNotEmpty) recipientNameController.text = recipientName;
    if (recipientNumber.isNotEmpty) recipientNumberController.text = recipientNumber;
    if (estimatedPrice.isNotEmpty) estimatedPriceController.text = estimatedPrice;
    if (parcelNote.isNotEmpty) noteController.text = parcelNote;
    if (packageWeightKg.isNotEmpty) packageWeightController.text = packageWeightKg;
    if (packageHeightCm.isNotEmpty) packageHeightController.text = packageHeightCm;
    if (packageWidthCm.isNotEmpty) packageWidthController.text = packageWidthCm;
    if (packageLengthCm.isNotEmpty) packageLengthController.text = packageLengthCm;
    autoAcceptController.sink.add(autoAccept == 1);
  }

  final formKey = GlobalKey<FormState>();
  final offerFareController = TextEditingController();
  final paymentListController = BehaviorSubject<List<PaymentTypeModel>>();
  final selectedPaymentController = BehaviorSubject<PaymentTypeModel?>();
  final destinationPaymentListController = BehaviorSubject<List<DestinationPaymentOption>>();
  final selectedDestinationPaymentController = BehaviorSubject<DestinationPaymentOption?>();
  final showScheduleController = BehaviorSubject<bool>();
  final scheduleDateTimeController = BehaviorSubject<DateTime?>();
  final autoAcceptController = BehaviorSubject<bool>();
  final recipientNameController = TextEditingController();
  final recipientNumberController = TextEditingController();
  final countryCodeController = BehaviorSubject<CountryCode>();
  final estimatedPriceController = TextEditingController();
  final noteController = TextEditingController();
  final packageWeightController = TextEditingController();
  final packageHeightController = TextEditingController();
  final packageWidthController = TextEditingController();
  final packageLengthController = TextEditingController();
  final selectedDeliveryVehicleServiceIdSubject = BehaviorSubject<int?>();

  void selectDeliveryVehicle(int? vehicleServiceId) {
    selectedDeliveryVehicleServiceIdSubject.add(vehicleServiceId);
  }

  void setPaymentTypeList(int paymentType) {
    final paymentList = <PaymentTypeModel>[
      if (getBoolFromSettingBox(hivePaymentTypeCash)) PaymentTypeModel(type: PaymentType.cash, name: languages.cash),
      if (getBoolFromSettingBox(hivePaymentTypeOnline)) PaymentTypeModel(type: PaymentType.online, name: languages.onlinePayment),
      if (getBoolFromSettingBox(hivePaymentTypeWallet)) PaymentTypeModel(type: PaymentType.wallet, name: languages.wallet),
    ];
    paymentListController.sink.add(paymentList);
    if (paymentList.isNotEmpty) {
      final index = paymentList.indexWhere((element) => element.type == paymentType);
      selectedPaymentController.sink.add(index >= 0 ? paymentList[index] : paymentList.first);
    }
  }

  void setDestinationPaymentList(String selectedCode) {
    final isSpanish = getLanguageFromUserPrefBox().startsWith('es');
    final options = DestinationPaymentUtil.optionsForLocale(isSpanish);
    destinationPaymentListController.sink.add(options);
    final match = options.where((o) => o.code == selectedCode);
    selectedDestinationPaymentController.sink.add(match.isNotEmpty ? match.first : options.first);
  }

  void onSubmitValue() {
    if ((showScheduleController.valueOrNull ?? false) && scheduleDateTimeController.valueOrNull == null) {
      openSimpleSnackbar(context, languages.selectScheduleDate);
      return;
    }
    if (selectedDestinationPaymentController.valueOrNull == null) {
      openSimpleSnackbar(context, languages.paymentMethod);
      return;
    }
    if ((isCourier || isEncomienda) &&
        deliveryOptions.isNotEmpty &&
        (selectedDeliveryVehicleServiceIdSubject.valueOrNull ?? 0) <= 0) {
      openSimpleSnackbar(context, 'Selecciona el vehículo.');
      return;
    }
    onSubmit(
      offerFareController.text.trim(),
      selectedPaymentController.valueOrNull?.type ?? PaymentType.cash,
      selectedDestinationPaymentController.valueOrNull!.code,
      scheduleDateTimeController.valueOrNull,
      (autoAcceptController.valueOrNull ?? false) ? 1 : 0,
      recipientNameController.text.trim(),
      recipientNumberController.text.isNotEmpty
          ? normalizeColombiaLocalMobile(
              recipientNumberController.text.trim(),
              dialCode: normalizeDialCode(countryCodeController.valueOrNull?.dialCode),
            )
          : '',
      estimatedPriceController.text.trim(),
      noteController.text.trim(),
      packageWeightController.text.trim(),
      packageHeightController.text.trim(),
      packageWidthController.text.trim(),
      packageLengthController.text.trim(),
      selectedDeliveryVehicleServiceIdSubject.valueOrNull ?? 0,
    );
  }

  @override
  void dispose() {
    offerFareController.dispose();
    paymentListController.close();
    selectedPaymentController.close();
    destinationPaymentListController.close();
    selectedDestinationPaymentController.close();
    showScheduleController.close();
    scheduleDateTimeController.close();
    autoAcceptController.close();
    recipientNameController.dispose();
    recipientNumberController.dispose();
    countryCodeController.close();
    estimatedPriceController.dispose();
    noteController.dispose();
    packageWeightController.dispose();
    packageHeightController.dispose();
    packageWidthController.dispose();
    packageLengthController.dispose();
    selectedDeliveryVehicleServiceIdSubject.close();
  }
}
