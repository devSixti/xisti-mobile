import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/no_record_found.dart';
import '../../../networking/api_base_helper.dart';
import '../../../utils/utils.dart';
import 'help_and_support_bloc.dart';
import 'help_and_support_dl.dart';
import 'help_and_support_shimmer.dart';
import 'support_detail_page.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  HelpAndSupportState createState() => HelpAndSupportState();
}

class HelpAndSupportState extends State<HelpAndSupport> {
  HelpAndSupportBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= HelpAndSupportBloc(context);
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
        centerTitle: true,
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        title: Text(languages.help, style: toolbarStyle(context: context)),
      ),
      body: _buildHelpAndSupport(context),
    );
  }

  Widget _buildHelpAndSupport(BuildContext context) {
    return StreamBuilder<ApiResponse<SupportPojo>>(
      stream: _bloc?.subject,
      builder: (context, snap) {
        var isLoading = snap.hasData && snap.data?.status == Status.loading;
        var isError = snap.hasData && snap.data?.status == Status.error;
        Widget simmerView = HelpAndSupportShimmer(enabled: isLoading);
        List<Pages> pageList = (snap.data != null && snap.data?.data != null && snap.data?.data?.pages != null) ? snap.data?.data?.pages ?? [] : [];
        return isLoading
            ? simmerView
            : (!isError && pageList.isNotEmpty)
            ? ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsetsDirectional.only(top: 10.h),
                separatorBuilder: (context, index) {
                  return Container(height: 20.h);
                },
                itemCount: pageList.length,
                itemBuilder: (BuildContext context, position) {
                  return GestureDetector(
                    onTap: () {
                      if ((pageList[position].description).isNotEmpty) {
                        openScreen(context, SupportDetailPage(title: pageList[position].pageName, pageDetail: pageList[position].description));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              snap.data != null ? pageList[position].pageName : "",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize18px),
                            ),
                          ),
                          Transform(
                            alignment: AlignmentDirectional.center,
                            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
                            child: Icon(CustomIcons.arrowForward, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : NoRecordFound(message: snap.data?.message ?? "");
      },
    );
  }
}
