import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/custom_drop_down_with_text_filed_custom.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/custom_text_field.dart';
import '../../../commonView/no_record_found.dart';
import '../../../commonView/xisti_vehicle_image.dart';
import '../../../constant/constant.dart';
import '../../../main.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_vehicle_catalog.dart';
import '../../../utils/validator.dart';
import 'driver_vehicle_details_bloc.dart';
import 'driver_vehicle_details_dl.dart';
import 'driver_vehicle_details_shimmer.dart';

class DriverVehicleDetailsScreen extends StatefulWidget {
  const DriverVehicleDetailsScreen({super.key});

  @override
  State<DriverVehicleDetailsScreen> createState() => _DriverVehicleDetailsScreenState();
}

class _DriverVehicleDetailsScreenState extends State<DriverVehicleDetailsScreen> {
  DriverVehicleDetailsBloc? _bloc;
  List<String> yearSelectionList = yearPickerList();

  @override
  void didChangeDependencies() {
    _bloc ??= DriverVehicleDetailsBloc(context);
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
      appBar: CommonAppBar(
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: Text(languages.manageVehicle, style: toolbarStyle(context: context)),
        centerTitle: true,
      ),
      body: StreamBuilder<ApiResponse<DriverVehicleListPojo>>(
        stream: _bloc?.driverVehicleListSubject,
        builder: (context, snapDriverVehicleList) {
          final serviceList = _bloc?.serviceList ?? [];
          switch (snapDriverVehicleList.data?.status ?? Status.loading) {
            case Status.loading:
              return DriverVehicleDetailsShimmer();
            case Status.completed:
              if (serviceList.isEmpty) {
                return NoRecordFound(message: snapDriverVehicleList.data?.message ?? "");
              }
              return _buildManageVehicleScreen(serviceList);
            case Status.error:
              return NoRecordFound(message: snapDriverVehicleList.data?.message ?? "");
          }
        },
      ),
    );
  }

  Widget _buildManageVehicleScreen(List<ServiceList> serviceList) {
    return StreamBuilder<ServiceList>(
      stream: _bloc?.serviceTypeSelection,
      builder: (context, snapSelectVehicleItem) {
        ServiceList selectServiceListItem = snapSelectVehicleItem.data ?? ServiceList();
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(top: 20.h, bottom: 80.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(languages.vehicleInformation, style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize22px)),
                  SizedBox(height: 15.h),
                  _vehicleFamilySelectionView(allServices: serviceList, selected: selectServiceListItem),
                  _vehicleServiceDataView(),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: StreamBuilder<ApiResponse<UploadVehiclePojo>>(
                stream: _bloc?.subjectUploadVehicleDetails,
                builder: (context, uploadVehicleDetails) {
                  return CustomRoundedButton(
                    context,
                    languages.submit,
                    () {
                      if (_bloc?.formKey.currentState?.validate() ?? false) {
                        _bloc?.uploadVehicleData();
                      }
                    },
                    setProgress: uploadVehicleDetails.data?.status == Status.loading,
                    minWidth: double.infinity,
                    margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _vehicleFamilySelectionView({required List<ServiceList> allServices, required ServiceList selected}) {
    final isMoto = selected.serviceId == ServiceType.bike;
    final isCar = selected.serviceId == ServiceType.taxi;
    final isBike = selected.serviceId == ServiceType.courier ||
        selected.deliveryVariant == XistiVehicleCatalog.bicicleta;

    Widget familyChip({required String label, required String iconVariant, required bool active, required VoidCallback onTap}) {
      final theme = getCurrentTheme(context);
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsetsDirectional.only(end: 8.w),
            padding: EdgeInsetsDirectional.symmetric(vertical: 20.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: active ? theme.colorPrimary : theme.colorBorder.withValues(alpha: 0.5),
                width: active ? 2.w : 1.w,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                XistiVehicleImage(imagePath: XistiVehicleCatalog.iconAsset(iconVariant), size: 96.w),
                SizedBox(height: 8.h),
                Text(label, style: bodyText(context: context, fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 20.h),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            familyChip(
              label: languages.vehicleMoto,
              iconVariant: XistiVehicleCatalog.motoMedio,
              active: isMoto,
              onTap: () {
                final variants = _bloc?.variantsForFamily(ServiceType.bike) ?? [];
                if (variants.isNotEmpty) _bloc?.selectTransportVariant(variants.first);
              },
            ),
            familyChip(
              label: languages.vehicleCarro,
              iconVariant: XistiVehicleCatalog.carroEco,
              active: isCar,
              onTap: () {
                final variants = _bloc?.variantsForFamily(ServiceType.taxi) ?? [];
                if (variants.isNotEmpty) _bloc?.selectTransportVariant(variants.first);
              },
            ),
            familyChip(
              label: languages.vehicleBicicleta,
              iconVariant: XistiVehicleCatalog.bicicleta,
              active: isBike,
              onTap: () {
                final bike = _bloc?.serviceList
                        .where((s) =>
                            s.serviceId == ServiceType.courier ||
                            s.deliveryVariant == XistiVehicleCatalog.bicicleta)
                        .toList() ??
                    [];
                if (bike.isNotEmpty) _bloc?.selectTransportVariant(bike.first);
              },
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _vehicleVariantSelection(selected: selected),
      ],
    ),
    );
  }

  Widget _vehicleVariantSelection({required ServiceList selected}) {
    final variants = _bloc?.variantsForFamily(selected.serviceId) ?? [];
    if (variants.isEmpty) return const SizedBox.shrink();

    return CustomDropDownFieldWithTextFieldCustom<ServiceList>(
      selectionItemList: variants,
      selectedItemStream: _bloc?.serviceTypeSelection,
      selectedItemTEC: _bloc?.variantTEC ?? TextEditingController(),
      getLabel: (item) => item.serviceName,
      isSelected: (item, selectedItem) =>
          item.serviceId == selectedItem.serviceId && item.deliveryVariant == selectedItem.deliveryVariant,
      commonPrefixIcon: CustomIcons.vehicleInformation,
      hintText: languages.selectVehicleType,
      validator: (value) => validateEmptyField(value, languages.selectVehicleType),
    );
  }

  Widget _vehicleServiceDataView() {
    return Form(
      key: _bloc?.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: 20.h),
            child: TextFormFieldCustom(
              controller: _bloc?.manufactureNameTEC,
              keyboardType: TextInputType.text,
              hint: languages.manufactureName,
              commonPrefixIcon: CustomIcons.manufactureName,
              setError: true,
              validator: (value) {
                return validateEmptyField(value, languages.enterManufactureName);
              },
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: 20.h),
            child: TextFormFieldCustom(
              controller: _bloc?.modelNameTEC,
              keyboardType: TextInputType.text,
              hint: languages.modelName,
              setError: true,
              commonPrefixIcon: CustomIcons.modelName,
              validator: (value) {
                return validateEmptyField(value, languages.enterModelName);
              },
            ),
          ),
          Padding(padding: EdgeInsetsDirectional.only(bottom: 20.h), child: _vehicleYearSelection()),
          StreamBuilder<ServiceList?>(
            stream: _bloc?.serviceTypeSelection,
            builder: (context, serviceSnap) {
              final service = serviceSnap.data;
              final showTechnical = service?.requiresTechnicalInspection == true || service?.serviceId == ServiceType.taxi;
              if (!showTechnical) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsetsDirectional.only(bottom: 20.h),
                child: TextFormFieldCustom(
                  controller: _bloc?.technicalInspectionExpiryTEC,
                  readOnly: true,
                  onTap: () => _bloc?.selectTechnicalInspectionExpiry(),
                  hint: languages.tecnomecanicaExpiryOptional,
                  commonPrefixIcon: CustomIcons.modelYear,
                ),
              );
            },
          ),

          Padding(
            padding: EdgeInsetsDirectional.only(bottom: 20.h),
            child: TextFormFieldCustom(
              controller: _bloc?.vehiclePlateNumberTEC,
              keyboardType: TextInputType.text,
              hint: languages.vehiclePlateNumber,
              setError: true,
              commonPrefixIcon: CustomIcons.referralCode,
              validator: (value) {
                return vehiclePlateValidate(
                  value,
                  vehicleTypeId: _bloc?.vehicleTypeSelection.valueOrNull?.vehicleTypeId,
                  serviceId: _bloc?.serviceTypeSelection.valueOrNull?.serviceId,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: 20.h),
            child: TextFormFieldCustom(
              controller: _bloc?.vehicleColorTEC,
              keyboardType: TextInputType.text,
              hint: languages.vehicleColor,

              setError: true,
              commonPrefixIcon: CustomIcons.vehicleColor,
              validator: (value) {
                return validateEmptyField(value, languages.enterVehicleColor);
              },
            ),
          ),

          _vehiclePhotoRow('Foto frontal', _bloc?.vehicleImageFrontFile, _bloc?.vehicleImageFrontUrl, () => _bloc?.addVehiclePhoto(_bloc!.vehicleImageFrontFile)),
          _vehiclePhotoRow('Foto lateral', _bloc?.vehicleImageSideFile, _bloc?.vehicleImageSideUrl, () => _bloc?.addVehiclePhoto(_bloc!.vehicleImageSideFile)),
          _vehiclePhotoRow('Foto trasera', _bloc?.vehicleImageRearFile, _bloc?.vehicleImageRearUrl, () => _bloc?.addVehiclePhoto(_bloc!.vehicleImageRearFile)),
          _transportDriverOptions(),
        ],
      ),
    );
  }

  Widget _transportDriverOptions() {
    return StreamBuilder<ServiceList>(
      stream: _bloc?.serviceTypeSelection,
      builder: (context, snapService) {
        final service = snapService.data;
        if (service == null) {
          return const SizedBox.shrink();
        }
        final isCar = service.serviceId == ServiceType.taxi;
        final showTaxi = XistiVehicleCatalog.showTaxiOptionForVariant(service.deliveryVariant);
        final showDeliveryToggle = service.supportsPassengerTransportToggle == true;

        return Column(
          children: [
            if (showDeliveryToggle) _alsoTransportPassengersToggle(),
            if (isCar) ...[
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 20.h, top: 4.h),
                child: StreamBuilder<bool>(
                  stream: _bloc?.childSafetyController,
                  builder: (context, snap) {
                    final value = snap.data ?? false;
                    return GestureDetector(
                      onTap: () => _bloc?.childSafetyController.sink.add(!value),
                      child: Row(
                        children: [
                          Expanded(child: Text(languages.childSeatSafety, style: bodyText(context: context, fontWeight: FontWeight.w500))),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: value,
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              checkColor: getCurrentTheme(context).colorWhite,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                              side: BorderSide(color: getCurrentTheme(context).colorBorder, width: 1.sp),
                              onChanged: (v) => _bloc?.childSafetyController.sink.add(v ?? false),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 20.h),
                child: StreamBuilder<bool>(
                  stream: _bloc?.handyCapAccessibilityController,
                  builder: (context, snap) {
                    final value = snap.data ?? false;
                    return GestureDetector(
                      onTap: () => _bloc?.handyCapAccessibilityController.sink.add(!value),
                      child: Row(
                        children: [
                          Expanded(child: Text(languages.handicapAccess, style: bodyText(context: context, fontWeight: FontWeight.w500))),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: value,
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              checkColor: getCurrentTheme(context).colorWhite,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                              side: BorderSide(color: getCurrentTheme(context).colorBorder, width: 1.sp),
                              onChanged: (v) => _bloc?.handyCapAccessibilityController.sink.add(v ?? false),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            if (showTaxi)
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 20.h),
                child: StreamBuilder<bool>(
                  stream: _bloc?.isTaxiController,
                  builder: (context, snap) {
                    final value = snap.data ?? false;
                    return GestureDetector(
                      onTap: () => _bloc?.isTaxiController.sink.add(!value),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Opero como taxi (opcional)',
                              style: bodyText(context: context, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: value,
                              onChanged: (v) => _bloc?.isTaxiController.sink.add(v ?? false),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _alsoTransportPassengersToggle() {
    return StreamBuilder<ServiceList>(
      stream: _bloc?.serviceTypeSelection,
      builder: (context, snapService) {
        final service = snapService.data;
        if (!(service?.supportsPassengerTransportToggle ?? false)) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsetsDirectional.only(bottom: 20.h, top: 4.h),
          child: StreamBuilder<bool>(
            stream: _bloc?.alsoTransportPassengersController,
            builder: (context, snap) {
              final value = snap.data ?? false;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _bloc?.alsoTransportPassengersController.sink.add(!value),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            languages.alsoTransportPassengers,
                            style: bodyText(context: context, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Checkbox(
                          value: value,
                          onChanged: (v) => _bloc?.alsoTransportPassengersController.sink.add(v ?? false),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    service?.isDeliveryOnlyService == true
                        ? languages.deliveryOnlyServiceHint
                        : languages.passengerTransportToggleHint,
                    style: bodyText(context: context, fontSize: textSize12px, textColor: getCurrentTheme(context).colorTextLight),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _vehicleYearSelection() {
    if (yearSelectionList.isEmpty) return SizedBox(height: 0, width: 0);
    return CustomDropDownFieldWithTextFieldCustom<String>(
      selectionItemList: yearSelectionList,
      selectedItemStream: _bloc?.vehicleYearSelection,
      selectedItemTEC: _bloc?.vehicleYearTEC ?? TextEditingController(),
      getLabel: (item) {
        return item;
      },
      isSelected: (item, selectedItem) {
        return item == selectedItem;
      },
      commonPrefixIcon: CustomIcons.modelYear,
      hintText: languages.vehicleYear,
      validator: (value) {
        return validateEmptyField(value, languages.selectVehicleYear);
      },
    );
  }

  Widget _vehiclePhotoRow(
    String label,
    BehaviorSubject<File?>? fileSubject,
    BehaviorSubject<String>? urlSubject,
    VoidCallback onTap,
  ) {
    return StreamBuilder<File?>(
      stream: fileSubject?.stream,
      builder: (context, snapFile) {
        return StreamBuilder<String>(
          stream: urlSubject?.stream,
          builder: (context, snapUrl) {
            final done = (snapFile.data?.path ?? '').isNotEmpty || (snapUrl.data ?? '').isNotEmpty;
            return GestureDetector(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                height: 45.h,
                margin: EdgeInsetsDirectional.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: getCurrentTheme(context).colorTextFieldBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(width: 1.w, color: getCurrentTheme(context).colorTextFieldBorder),
                ),
                padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Icon(
                      done ? Icons.check_circle_sharp : CustomIcons.imageIcon,
                      color: done ? getCurrentTheme(context).colorGreen : getCurrentTheme(context).colorIconCommon,
                      size: 24.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        done ? languages.imageUploaded : label,
                        style: bodyText(
                          context: context,
                          textColor: done ? getCurrentTheme(context).colorGreen : getCurrentTheme(context).colorTextLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(CustomIcons.uploadImage, color: done ? getCurrentTheme(context).colorGreen : getCurrentTheme(context).colorIconCommon, size: 24.sp),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
