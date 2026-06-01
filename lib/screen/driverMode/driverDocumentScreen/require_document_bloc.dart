import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/utils.dart';
import 'addDocument/add_document.dart';
import 'require_document_dl.dart';
import 'required_document_repo.dart';

class RequireDocumentBloc extends Bloc {
  final BehaviorSubject<List<DocumentList>> _requiredDocumentListController = BehaviorSubject<List<DocumentList>>();
  final _subject = BehaviorSubject<ApiResponse<RequireDocument>>();
  final _subjectSingleDocUpload = BehaviorSubject<ApiResponse<UploadSingleDocPojo>>();
  late BuildContext context;
  late bool isFromHomeScreen;
  final RequiredDocumentRepo _requiredDocumentRepo = RequiredDocumentRepo();

  RequireDocumentBloc(this.context, this.isFromHomeScreen) {
    callManageDocumentListApi();
  }

  Stream<List<DocumentList>> get requiredDocumentList => _requiredDocumentListController.stream;

  BehaviorSubject<ApiResponse<RequireDocument>> get subject => _subject;

  BehaviorSubject<ApiResponse<UploadSingleDocPojo>> get subjectSingleDocUpload => _subjectSingleDocUpload;

  Function(List<DocumentList>) get changeRequiredDocumentList => _requiredDocumentListController.sink.add;

  Future<void> callManageDocumentListApi() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => callManageDocumentListApi())) {
      _subject.sink.add(ApiResponse.loading());
      try {
        var response = RequireDocument.fromJson(await _requiredDocumentRepo.manageDocumentListApi());

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message ?? "", true)) {
          _subject.sink.add(ApiResponse.completed(response));
          changeRequiredDocumentList(response.documentList ?? []);
        } else {
          _subject.sink.add(ApiResponse.error(response.message));
          if (response.status != 3) openSimpleSnackbar(context, response.message ?? "");
        }
      } catch (e) {
        debugPrint(e.toString());
        _subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void addUpdateDocument(int position, DocumentList documentList) {
    openScreen(
      context,
      AddDocument(
        documentListItem: documentList,
        onUpload: (documentList) {
          changeRequiredDocumentList(documentList);
        },
      ),
    );
  }

  @override
  void dispose() {
    _requiredDocumentListController.close();
    _subject.close();
    _subjectSingleDocUpload.close();
  }
}
