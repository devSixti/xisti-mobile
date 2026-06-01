import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/no_record_found.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/api_response.dart';
import '../../../utils/utils.dart';
import '../../passengerMode/passengerHome/passenger_home.dart';
import '../driverHome/driver_home.dart';
import 'document_item.dart';
import 'require_document_bloc.dart';
import 'require_document_dl.dart';
import 'require_document_shimmer.dart';

class RequireDocumentScreen extends StatefulWidget {
  final bool isFromHomeScreen;

  const RequireDocumentScreen({super.key, this.isFromHomeScreen = false});

  @override
  State createState() => _RequireDocumentScreenState();
}

class _RequireDocumentScreenState extends State<RequireDocumentScreen> {
  RequireDocumentBloc? _requireDocumentBloc;

  @override
  void didChangeDependencies() {
    _requireDocumentBloc ??= RequireDocumentBloc(context, widget.isFromHomeScreen);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _requireDocumentBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true);
        } else {
          if (getIntFromSettingBox(hiveAppMode) == AppMode.driver) {
            openScreenWithClearPrevious(context, const DriverHome());
          } else {
            openScreenWithClearPrevious(context, const PassengerHome());
          }
        }
      },
      child: ScaffoldWithSafeArea(
        appBar: CommonAppBar(
          titleTextStyle: toolbarStyle(context: context),
          leading: backButtonForAppBarCustom(
            context: context,
            onBackPress: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context, true);
              } else {
                if (getIntFromSettingBox(hiveAppMode) == AppMode.driver) {
                  openScreenWithClearPrevious(context, const DriverHome());
                } else {
                  openScreenWithClearPrevious(context, const PassengerHome());
                }
              }
            },
          ),
          centerTitle: true,
          title: Text(languages.document),
        ),
        body: StreamBuilder<ApiResponse<RequireDocument>>(
          stream: _requireDocumentBloc?.subject,
          builder: (context, snap) {
            var isLoading = snap.hasData && snap.data!.status == Status.loading;
            var isError = snap.hasData && snap.data?.status == Status.error;
            return isLoading
                ? RequireDocumentShimmer(enabled: isLoading)
                : (!isError)
                ? StreamBuilder<List<DocumentList>>(
                  stream: _requireDocumentBloc?.requiredDocumentList,
                  builder: (context, snapshot) {
                    List<DocumentList> documentList = snapshot.data ?? [];
                    return documentList.isNotEmpty
                        ? ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsetsDirectional.only(top: 20.h, bottom: 80.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
                          itemBuilder: (context, index) {
                            return DocumentItem(
                              requiredDocumentListItem: snapshot.data![index],
                              requireDocumentBloc: _requireDocumentBloc!,
                              onPressUpload: () {
                                _requireDocumentBloc?.addUpdateDocument(index, snapshot.data![index]);
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              height: 1.h,
                              width: double.infinity,
                              color: getCurrentTheme(context).colorLoginLine,
                              margin: EdgeInsetsDirectional.only(top: 20.h, bottom: 20.h),
                            );
                          },
                          itemCount: documentList.length,
                        )
                        : NoRecordFound(message: languages.emptyDocument);
                  },
                )
                : NoRecordFound(message: languages.emptyDocument);
          },
        ),
      ),
    );
  }
}
