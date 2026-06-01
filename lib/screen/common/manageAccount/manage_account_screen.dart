import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../utils/utils.dart';
import '../account/account_dl.dart';
import 'item_manage_account.dart';
import 'manage_account_bloc.dart';

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({super.key});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  ManageAccountBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= ManageAccountBloc(context);
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
        title: Text(languages.manageAccount, style: toolbarStyle(context: context)),
      ),
      body: Container(
        margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
        child: StreamBuilder<List<ManageAccountItem>>(
          stream: _bloc?.accountItemSubject,
          builder: (context, snapAccountItems) {
            List<ManageAccountItem> accountList = snapAccountItems.data ?? [];
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
                  child: ItemManageAccount(accountItem: accountList[position]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
