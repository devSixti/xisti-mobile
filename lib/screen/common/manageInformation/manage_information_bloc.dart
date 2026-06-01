import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/utils.dart';
import '../../driverMode/driverDocumentScreen/require_document_screen.dart';
import '../../driverMode/driverVehicleDetails/driver_vehicle_details_screen.dart';
import '../account/account_dl.dart';

class ManageInformationBloc extends Bloc {
  final BuildContext context;

  final accountItemSubject = BehaviorSubject<List<ManageInformationItem>>();

  ManageInformationBloc(this.context) {
    getDrawerData();
  }

  void getDrawerData() {
    List<ManageInformationItem> accountItemsList = [
      ManageInformationItem(
        ManageInformationEnum.vehicleDetail,
        CustomIcons.vehicleInformation,
        languages.vehicleInformation,
        getIntFromSettingBox(hiveVehicleStatus) == 1,
      ),
      ManageInformationItem(
        ManageInformationEnum.requireDocument,
        CustomIcons.drivingLicence,
        languages.drivingLicence,
        getIntFromSettingBox(hiveDocumentStatus) == 1,
      ),
    ];
    accountItemSubject.add(accountItemsList);
  }

  void openAccountSelectedScreen(ManageInformationEnum accountEnum) {
    switch (accountEnum) {
      case ManageInformationEnum.vehicleDetail:
        openScreenWithResult(context, DriverVehicleDetailsScreen()).then((value) {
          getDrawerData();
        });
        break;
      case ManageInformationEnum.requireDocument:
        openScreenWithResult(context, RequireDocumentScreen()).then((value) {
          getDrawerData();
        });
        break;
    }
  }

  @override
  void dispose() {
    accountItemSubject.close();
  }
}
