import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/image_widget_placeholder.dart';
import '../../../commonView/statusView/document_status_view.dart';
import '../../../networking/api_response.dart';
import '../../../utils/utils.dart';
import 'require_document_bloc.dart';
import 'require_document_dl.dart';

class DocumentItem extends StatefulWidget {
  final DocumentList requiredDocumentListItem;
  final Function onPressUpload;
  final RequireDocumentBloc requireDocumentBloc;

  const DocumentItem({super.key, required this.requiredDocumentListItem, required this.onPressUpload, required this.requireDocumentBloc});

  @override
  State createState() => _DocumentItemState();
}

class _DocumentItemState extends State<DocumentItem> {
  @override
  Widget build(BuildContext context) {
    String expiryDate = (widget.requiredDocumentListItem.documentExpireDate ?? "").trim();
    ImageProvider file;
    file = const AssetImage("assets/images/img_error_doc.png");

    if ((widget.requiredDocumentListItem.selectedImgFile != null)) {
      if (widget.requiredDocumentListItem.selectedImgFile!.path.toLowerCase().endsWith(".pdf")) {
        file = const AssetImage("assets/images/img_pdf.png");
      } else {
        file = FileImage(widget.requiredDocumentListItem.selectedImgFile!);
      }
    }
    if (((widget.requiredDocumentListItem.documentFile ?? "").isNotEmpty)) {
      if ((widget.requiredDocumentListItem.documentFile ?? "").toLowerCase().endsWith(".pdf")) {
        file = const AssetImage("assets/images/img_pdf.png");
      } else {
        file = NetworkImage(widget.requiredDocumentListItem.documentFile ?? "");
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), border: Border.all(color: getCurrentTheme(context).colorBorder, width: 0.5.w)),
          child: ImageWidgetPlaceholder(
            image: file,
            size: 100.sp,
            fit: BoxFit.contain,
            placeholder: Shimmer.fromColors(
              baseColor: getCurrentTheme(context).colorShimmerBg,
              highlightColor: getCurrentTheme(context).colorBorder,
              period: const Duration(milliseconds: 800),
              child: Container(color: getCurrentTheme(context).colorShimmerBg),
            ),
            radius: 10.r,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 5.h),
                child: Text(
                  widget.requiredDocumentListItem.documentName ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: bodyText(context: context, fontWeight: FontWeight.w600),
                ),
              ),
              if (widget.requiredDocumentListItem.containsExpiry == 1)
                Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 10.h),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: "${languages.expiryDate} : ",
                      style: bodyText(
                        context: context,
                        textColor: getCurrentTheme(context).colorTextLight,
                        fontWeight: FontWeight.w500,
                        fontSize: textSize14px,
                      ),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Text(
                            expiryDate.isNotEmpty ? getDateTime(expiryDate, format: "yyyy-MM-dd", returnFormat: "dd MMM yyyy", showOnlyDate: true) : "-",
                            textAlign: TextAlign.center,
                            style: bodyText(context: context, fontWeight: FontWeight.w500, fontSize: textSize14px),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              DocumentStatusView(docStatus: widget.requiredDocumentListItem.documentStatus ?? 0),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        if (widget.requiredDocumentListItem.documentStatus != 1)
          Container(
            alignment: AlignmentDirectional.bottomEnd,
            width: 80.w,
            child: StreamBuilder<ApiResponse>(
              stream: widget.requireDocumentBloc.subjectSingleDocUpload,
              builder: (context, snapshot) {
                return CustomRoundedButton(
                  context,
                  widget.requiredDocumentListItem.documentStatus == 4 ? languages.upload : languages.update,
                  (widget.requiredDocumentListItem.isLoading)
                      ? null
                      : () {
                        widget.onPressUpload();
                      },
                  minWidth: 65.w,
                  minHeight: 30.h,
                  setBorder: true,
                  textSize: textSize14px,
                  setProgress: widget.requiredDocumentListItem.isLoading,
                );
              },
            ),
          ),
      ],
    );
  }
}
