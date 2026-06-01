import 'dart:convert';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as p_handler;

import '../blocs/bloc.dart';
import '../hive/hive_helper.dart';
import '../screen/driverMode/driverRideDetail/driver_ride_detail.dart';
import '../screen/passengerMode/passengerRideDetail/passenger_ride_detail.dart';
import 'utils.dart';

DownloadTask? backgroundDownloadTask;
BehaviorSubject<bool> fileDownloadingSubject = BehaviorSubject();

@pragma('vm:entry-point')
void initFileDownloader() {
  FileDownloader()
      .configure(
        globalConfig: [(Config.requestTimeout, const Duration(seconds: 100))],
        androidConfig: [(Config.useCacheDir, Config.whenAble)],
        iOSConfig: [
          (Config.localize, {'Cancel': 'StopIt'}),
        ],
      )
      .then((result) => debugPrint('Configuration result = $result'));

  // Registering a callback and configure notifications
  FileDownloader().registerCallbacks(taskNotificationTapCallback: myNotificationTapCallback);

  FileDownloader().updates.listen((update) {
    switch (update) {
      case TaskStatusUpdate():
        if (update.task == backgroundDownloadTask) {
          switch (update.status) {
            case TaskStatus.enqueued:
            case TaskStatus.running:
              fileDownloadingSubject.sink.add(true);
              break;
            case TaskStatus.complete:
              fileDownloadingSubject.sink.add(false);
              openSimpleSnackbar(navigatorKey.currentContext!, languages.pdfDownloadSuccessful);
              break;
            case TaskStatus.failed:
            case TaskStatus.canceled:
              fileDownloadingSubject.sink.add(false);
              openSimpleSnackbar(navigatorKey.currentContext!, languages.downloadCancelled);
              break;
            case TaskStatus.waitingToRetry:
            case TaskStatus.paused:
            case TaskStatus.notFound:
              fileDownloadingSubject.sink.add(false);
              break;
          }
        }
      case TaskProgressUpdate():
    }
  });
}

void downloadMyFile({required String pdfUrl, required String orderDate, required String bookingNo, required orderId}) async {
  DownloadDataModel downloadDataModel = DownloadDataModel(
    pdfUrl: pdfUrl,
    rideId: orderId,
    appMode: getIntFromSettingBox(hiveAppMode) == AppMode.driver ? AppMode.driver : AppMode.passenger,
  );

  try {
    await getExternalDocumentPath().then((documentPath) async {
      if (documentPath.isNotEmpty) {
        String fileName = '${languages.appName.replaceAll(" ", "-")}-${getDateTime(orderDate, returnFormat: "dd-MM-yyyy").replaceAll(":", "-")}-$bookingNo.pdf';
        backgroundDownloadTask = DownloadTask(
          url: pdfUrl,
          filename: fileName,
          directory: documentPath,
          baseDirectory: BaseDirectory.root,
          updates: Updates.statusAndProgress,
          allowPause: false,
          metaData: downloadDataModel.toJsonString(),
          displayName: fileName,
        );
        FileDownloader().configureNotificationForTask(
          backgroundDownloadTask!,
          running: TaskNotification(backgroundDownloadTask?.filename ?? "-", languages.downloading),
          complete: TaskNotification(backgroundDownloadTask?.filename ?? "-", languages.downloadingComplete),
          error: TaskNotification(backgroundDownloadTask?.filename ?? "-", languages.downloadingFailed),
          progressBar: true,
          tapOpensFile: true,
        );
        FileDownloader().enqueue(backgroundDownloadTask!);
      }
    });
  } catch (e) {
    debugPrint(e.toString());
  }
}

@pragma('vm:entry-point')
void myNotificationTapCallback(Task task, NotificationType notificationType) {
  if (notificationType == NotificationType.complete) {
    DownloadDataModel downloadDataModel = DownloadDataModel.fromJson(jsonDecode(task.metaData));
    switch (downloadDataModel.appMode) {
      default:
        openScreenWithClearPrevious(
          navigatorKey.currentContext!,
          getIntFromSettingBox(hiveAppMode) == AppMode.driver
              ? DriverRideDetail(rideId: downloadDataModel.rideId)
              : PassengerRideDetail(rideId: downloadDataModel.rideId),
        );
        break;
    }
  }
}

Future<String> getExternalDocumentPath() async {
  p_handler.PermissionStatus status = p_handler.PermissionStatus.denied;
  if (Platform.isAndroid) {
    int deviceInfo = int.parse(await FileDownloader().platformVersion());
    if (deviceInfo < 30) {
      status = await p_handler.Permission.storage.status;
      if (!status.isGranted) {
        await p_handler.Permission.storage.request();
      }
    }
  }

  String exPath = "";
  if (Platform.isAndroid) {
    exPath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD);
  } else {
    Directory directory = await getApplicationDocumentsDirectory();
    exPath = directory.path;
  }
  await Directory(exPath).create(recursive: true);
  return exPath;
}

class DownloadDataModel {
  String pdfUrl = "";
  int rideId = 0;
  int appMode = 0;

  DownloadDataModel({required this.pdfUrl, required this.rideId, required this.appMode});

  DownloadDataModel.fromJson(dynamic json) {
    pdfUrl = json["pdf_url"];
    rideId = json["ride_id"];
    appMode = json["app_mode"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["pdf_url"] = pdfUrl;
    map["ride_id"] = rideId;
    map["app_mode"] = appMode;
    return map;
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
