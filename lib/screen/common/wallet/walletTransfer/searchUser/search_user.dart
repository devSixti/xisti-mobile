import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../commonView/common_view.dart';
import '../../../../../commonView/custom_text_field.dart';
import '../../../../../commonView/load_image_with_placeholder.dart';
import '../../../../../commonView/no_record_found.dart';
import '../../../../../networking/api_response.dart';
import '../../../../../utils/utils.dart';
import '../wallet_transfer_bloc.dart';
import '../wallet_transfer_dl.dart';
import 'search_user_shimmer.dart';

class SearchUser extends StatefulWidget {
  final WalletTransferBloc bloc;

  const SearchUser({super.key, required this.bloc});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
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
        title: Hero(tag: 'SearchUser', child: Text(languages.searchByContactOrEmail, style: toolbarStyle(context: context))),
      ),
      body: _buildSearchUser(context),
    );
  }

  Widget _buildSearchUser(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 20.h),
          child: TextFormFieldCustom(
            decoration: InputDecoration(hintText: languages.searchByContactOrEmail),
            textInputAction: TextInputAction.search,
            controller: widget.bloc.searchUserTEC,
            setClear: true,
            commonPrefixIcon: CustomIcons.search,
            validator: (value) {
              return "";
            },
            onSubmit: (search) {
              if (search.trim().isNotEmpty) {
                widget.bloc.searchUsersApiCall(search);
              }
            },
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: StreamBuilder<ApiResponse<UserSearchModel>?>(
            stream: widget.bloc.searchUserSubject,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: commonHorizontalPadding),
                  child: Center(child: Text(languages.enterContactOrEmailToSearchPerson, textAlign: TextAlign.center, style: bodyText(context: context))),
                );
              } else {
                switch (snapshot.data?.status ?? Status.loading) {
                  case Status.loading:
                    return const SearchUserShimmer();

                  case Status.error:
                    return NoRecordFound(message: snapshot.data?.message ?? "");

                  case Status.completed:
                    List<TransferUserList> transferUserList = snapshot.data?.data?.transferUserList ?? [];

                    return (transferUserList.isEmpty)
                        ? NoRecordFound(message: languages.noRecordFound)
                        : ListView.separated(
                          itemCount: transferUserList.length,
                          padding: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: commonHorizontalPadding),
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(height: 40.h, color: getCurrentTheme(context).colorDivider, thickness: 1.sp);
                          },
                          itemBuilder: (context, index) {
                            TransferUserList? transferUser = transferUserList[index];

                            String contactNumber = "${transferUser.countryCode} ${transferUser.contactNumber}";

                            return GestureDetector(
                              onTap: () {
                                widget.bloc.transferUserList = transferUser;
                                widget.bloc.textBeneficialNameTEC.text = transferUser.name;
                                widget.bloc.textNumberTEC.text = contactNumber;
                                widget.bloc.textEmailTEC.text = transferUser.email;
                                Navigator.pop(context, transferUser);
                              },
                              child: Row(
                                children: [
                                  LoadImageWithPlaceHolder(
                                    width: 70.sp,
                                    height: 70.sp,
                                    image: transferUser.profileImage,
                                    defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      spacing: 5.h,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(transferUser.name, style: bodyText(context: context, fontWeight: FontWeight.w600)),
                                        Text(contactNumber, style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w500)),
                                        Text(transferUser.email, style: bodyText(context: context, fontSize: textSize14px)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
