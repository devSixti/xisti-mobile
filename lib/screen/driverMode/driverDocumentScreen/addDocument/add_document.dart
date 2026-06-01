import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonView/common_view.dart';
import '../../../../commonView/custom_rounded_button.dart';
import '../../../../commonView/custom_text_field.dart';
import '../../../../commonView/load_image_with_placeholder.dart';
import '../../../../networking/api_response.dart';
import '../../../../utils/destination_payment_util.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/validator.dart';
import '../require_document_dl.dart';
import 'add_document_bloc.dart';

class AddDocument extends StatefulWidget {
  final DocumentList documentListItem;
  final Function(List<DocumentList> documentList) onUpload;

  const AddDocument({required this.documentListItem, required this.onUpload, super.key});

  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  late AddDocumentBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = AddDocumentBloc(context, widget.documentListItem, widget.onUpload);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
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
        title: Text(
          (widget.documentListItem.documentFile ?? "").isNotEmpty ? languages.updateDocument : languages.uploadDocument,
          style: toolbarStyle(context: context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 25.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<File>(
                    stream: _bloc.documentImageFile,
                    builder: (context, snapImageFile) {
                      File? selectedImageFile = snapImageFile.data;
                      bool isNoDocument = selectedImageFile == null && (widget.documentListItem.documentFile ?? "").trim().isEmpty;
                      return GestureDetector(
                        onTap: () {
                          _bloc.selectDocument();
                        },
                        child:
                            isNoDocument //No document image view
                            ? AspectRatio(
                                aspectRatio: kDriverDocumentAspectRatio,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(width: 1.w, color: getCurrentTheme(context).colorBorder),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 10.w),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(CustomIcons.upload, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                                          SizedBox(height: 5.h),
                                          Text(
                                            languages.uploadImage,
                                            overflow: TextOverflow.ellipsis,
                                            style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Stack(
                                //Show document image with edit icon
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(top: 10.h, start: 8.w, end: 8.w),
                                    child: AspectRatio(
                                      aspectRatio: kDriverDocumentAspectRatio,
                                      child: selectedImageFile != null
                                          ? selectedImageFile.path.toLowerCase().endsWith(".pdf")
                                                ? AspectRatio(
                                                    aspectRatio: 1,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20.r),
                                                        border: Border.all(color: getCurrentTheme(context).colorBorder, width: 0.5),
                                                      ),
                                                      padding: EdgeInsetsDirectional.only(top: 5.w, bottom: 5.w),
                                                      child: Image.asset("assets/images/img_pdf.png", height: 50.sp, width: 50.sp),
                                                    ),
                                                  )
                                                : Stack(
                                                    children: [
                                                      Container(
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
                                                        child: Image.file(
                                                          selectedImageFile,
                                                          fit: BoxFit.contain,
                                                          width: double.infinity,
                                                          height: double.infinity,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        decoration: BoxDecoration(
                                                          color: getCurrentTheme(context).colorStaticBlack.withValues(alpha: 0.6),
                                                          borderRadius: BorderRadius.circular(20.r),
                                                          border: Border.all(width: 1.w, color: getCurrentTheme(context).colorBorder),
                                                        ),
                                                        child: Center(
                                                          child: Padding(
                                                            padding: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 10.w),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Icon(CustomIcons.upload, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                                                                SizedBox(height: 5.h),
                                                                Text(
                                                                  languages.uploadImage,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w500),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                          : (widget.documentListItem.documentFile ?? "").toLowerCase().endsWith(".pdf")
                                          ? AspectRatio(
                                              aspectRatio: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20.r),
                                                  border: Border.all(color: getCurrentTheme(context).colorBorder, width: 0.5),
                                                ),
                                                padding: EdgeInsetsDirectional.only(top: 5.w, bottom: 5.w),
                                                child: Image.asset("assets/images/img_pdf.png", height: 50.sp, width: 50.sp),
                                              ),
                                            )
                                          : Stack(
                                              children: [
                                                LoadImageWithPlaceHolder(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  image: (widget.documentListItem.documentFile ?? "").trim(),
                                                  imageFit: BoxFit.contain,
                                                  borderRadius: BorderRadius.circular(20.r),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: getCurrentTheme(context).colorStaticBlack.withValues(alpha: 0.6),
                                                    borderRadius: BorderRadius.circular(20.r),
                                                    border: Border.all(width: 1.w, color: getCurrentTheme(context).colorBorder),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 10.w),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(CustomIcons.upload, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                                                          SizedBox(height: 5.h),
                                                          Text(
                                                            languages.uploadImage,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5.sp),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r), color: getCurrentTheme(context).colorPrimary),
                                    child: Icon(CustomIcons.edit, color: getCurrentTheme(context).colorIconCommon, size: 20.sp),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                  if (widget.documentListItem.containsExpiry == 1)
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 25.h),
                      child: Form(
                        key: _bloc.formKey,
                        child: TextFormFieldCustom(
                          onTap: () {
                            _bloc.selectExpiryDate();
                          },
                          commonPrefixIcon: CustomIcons.editDate,
                          controller: _bloc.expiryDateTEC,
                          keyboardType: TextInputType.text,
                          hint: languages.selectExpiryDate,
                          setError: true,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          validator: (value) {
                            return validateEmptyField(value, languages.selectExpiryDate);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: StreamBuilder<ApiResponse<UploadSingleDocPojo>>(
              stream: _bloc.subjectSingleDocUpload,
              builder: (context, snapUploadDoc) {
                var isLoading = snapUploadDoc.hasData && snapUploadDoc.data?.status == Status.loading;
                return CustomRoundedButton(
                  context,
                  (widget.documentListItem.documentFile ?? "").isNotEmpty ? languages.updateDocument : languages.uploadDocument,
                  isLoading
                      ? null
                      : () {
                          _bloc.uploadDocument();
                        },
                  minWidth: double.infinity,
                  setProgress: isLoading,
                  margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
