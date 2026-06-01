import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../utils/utils.dart';
import '../account/account_dl.dart';
import 'item_manage_information.dart';
import 'manage_information_bloc.dart';

class ManageInformationScreen extends StatefulWidget {
  const ManageInformationScreen({super.key});

  @override
  State<ManageInformationScreen> createState() => _ManageInformationScreenState();
}

class _ManageInformationScreenState extends State<ManageInformationScreen> {
  ManageInformationBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= ManageInformationBloc(context);
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
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(languages.manageInformation, style: toolbarStyle(context: context)),
      ),
      body: Container(
        margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
        child: StreamBuilder<List<ManageInformationItem>>(
          stream: _bloc?.accountItemSubject,
          builder: (context, snapAccountItems) {
            List<ManageInformationItem> accountList = snapAccountItems.data ?? [];
            return ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsetsDirectional.only(top: 10.h),
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return Container(height: 20.h);
              },
              itemCount: accountList.length,
              itemBuilder: (BuildContext context, position) {
                return GestureDetector(
                  onTap: () {
                    _bloc?.openAccountSelectedScreen(snapAccountItems.data![position].manageAccountEnum);
                  },
                  child: ItemManageInformation(accountItem: accountList[position]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
