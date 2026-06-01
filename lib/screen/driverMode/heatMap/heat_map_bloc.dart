import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/utils.dart';
import 'heat_map_dl.dart';
import 'heat_map_repo.dart';

class HeatMapBloc extends Bloc {
  String tag = "HeatMap>>>";
  final BuildContext context;
  final HeatMapRepo _repo = HeatMapRepo();

  HeatMapBloc(this.context) {
    callHeatMapApi();
  }

  final heatMapApiController = BehaviorSubject<ApiResponse<HeatMapModel>>();

  Future<void> callHeatMapApi() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => callHeatMapApi())) {
      heatMapApiController.sink.add(ApiResponse.loading());
      try {
        var response = HeatMapModel.fromJson(await _repo.callHeatMapApi(0));
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          heatMapApiController.sink.add(ApiResponse.completed(response));
        } else {
          heatMapApiController.sink.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        heatMapApiController.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    heatMapApiController.close();
  }
}
