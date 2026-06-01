import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/no_record_found.dart';
import '../../../networking/api_response.dart';
import '../../../utils/utils.dart';
import 'heat_map_bloc.dart';
import 'heat_map_dl.dart';

class HeatMapScreen extends StatefulWidget {
  const HeatMapScreen({super.key});

  @override
  State<HeatMapScreen> createState() => _HeatMapScreenState();
}

class _HeatMapScreenState extends State<HeatMapScreen> {
  HeatMapBloc? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = _bloc ?? HeatMapBloc(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(
        centerTitle: true,
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        titleTextStyle: toolbarStyle(context: context),
        title: Text(languages.heatMap),
      ),
      body: StreamBuilder<ApiResponse<HeatMapModel>>(
        stream: _bloc?.heatMapApiController,
        builder: (context, snapshot) {
          var isLoading = snapshot.hasData && snapshot.data?.status == Status.loading;
          var isError = snapshot.hasData && snapshot.data?.status == Status.error;
          String? heatMapUrl;
          if (snapshot.data != null) {
            HeatMapModel? data = snapshot.data!.data;
            if (data != null) {
              heatMapUrl = data.heatMapUrl;
            }
          }
          if (isLoading || !snapshot.hasData) {
            return const FullScreenProgress();
          } else if (isError) {
            return NoRecordFound(message: languages.noRecordFound);
          } else {
            return InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(heatMapUrl ?? "")),
              initialSettings: InAppWebViewSettings(hardwareAcceleration: false, useHybridComposition: false),
            );
          }
        },
      ),
    );
  }
}
