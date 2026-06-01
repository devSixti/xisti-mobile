import 'dart:async';
import 'dart:io';

import 'package:appcheck/appcheck.dart';
import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'firebase_options.dart';
import 'hive/hive_helper.dart';
import 'l10n/appLocalization/app_localizations.dart';
import 'networking/base_dl.dart';
import 'screen/common/splash/splash_screen.dart';
import 'services/backgroundService/background_location_service.dart';
import 'services/backgroundService/location_service_repository.dart';
import 'services/push_notification_service.dart';
import 'utils/file_downloader.dart';
import 'utils/get_location_utils.dart';
import 'utils/shared_pref_util.dart';
import 'utils/utils.dart';

late AppLocalizations languages;
final navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final PushNotificationService pushNotificationService = PushNotificationService();
GetLocationUtils getLocationUtils = GetLocationUtils();
BackgroundLocationService backgroundLocationService = BackgroundLocationService();
LocationServiceRepository myLocationCallbackRepository = LocationServiceRepository();
late Box settingsBox;
late Box userInfoBox;
late Box userPrefBox;
String localTimeZone = "";
bool isTime24HoursFormat = false;
bool gestureNavigation = true;
final player = AudioPlayer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  localTimeZone = (await FlutterTimezone.getLocalTimezone()).identifier;

  ///initializing hive
  await Hive.initFlutter();

  ///initializing boxes and register adapters for hive...
  await initBox();

  tz.initializeTimeZones();
  await initSharedPreferences();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initAppConfig();
  initFileDownloader();
  try {
    final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      await mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
    }
  } catch (e) {
    logd(e.toString());
  }
  await _initPlayer();
  checkAndSetGestureNavigation();
  runApp(const MyApp());
}

Future<void> _initPlayer() async {
  // Try to load audio from a source and catch any errors.
  try {
    await player.setAsset('assets/audio/new_request.mp3');
    await player.setLoopMode(LoopMode.all);
  } catch (e) {
    logd("Error loading audio source: $e");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    isAppKilledOrTerminatedSubject.sink.add(false);
    pushNotificationService.configureSelectNotificationSubject();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      pushNotificationService.showNotificationInApp();
      await reloadSharedPreference();
      await isBackgroundNotification();
      await backgroundLocationService.initialise();
      checkAndSetGestureNavigation();
    });
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        checkAndSetGestureNavigation();
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await reloadSharedPreference();
          isBackgroundNotification();
          checkAndSetGestureNavigation();
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    isAppKilledOrTerminatedSubject.sink.add(true);
    pushNotificationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark));
    return ValueListenableBuilder(
      valueListenable: userPrefBox.listenable(),
      builder: (context, value, child) {
        Locale selectedLocale = Locale(getLanguageFromUserPrefBox());
        return ValueListenableBuilder(
          valueListenable: themeModeChangeListener,
          builder: (context, value, child) {
            AppThemeColors lightThemeColors = AppThemeColors.light();
            AppThemeColors darkThemeColors = AppThemeColors.dark();
            return ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (BuildContext context, Widget? child) {
                return GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: MaterialApp(
                    scaffoldMessengerKey: rootScaffoldMessengerKey,
                    navigatorKey: navigatorKey,
                    themeMode: getSelectedThemeMode(),
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      primaryColor: lightThemeColors.colorPrimary,
                      colorScheme: ThemeData().colorScheme.copyWith(primary: lightThemeColors.colorPrimary, secondary: lightThemeColors.colorPrimary,surface: lightThemeColors.colorScaffoldBg),
                      unselectedWidgetColor: lightThemeColors.colorPrimary,
                      textSelectionTheme: TextSelectionThemeData(cursorColor: lightThemeColors.colorPrimary),
                      fontFamily: GoogleFonts.figtree().fontFamily,
                      scaffoldBackgroundColor: lightThemeColors.colorScaffoldBg,
                      cardTheme: CardThemeData(color: lightThemeColors.colorWhite, surfaceTintColor: lightThemeColors.colorWhite),
                      popupMenuTheme: PopupMenuThemeData(color: lightThemeColors.colorWhite, surfaceTintColor: lightThemeColors.colorWhite),
                      bottomSheetTheme: BottomSheetThemeData(
                        backgroundColor: lightThemeColors.colorWhite,
                        modalBackgroundColor: Colors.transparent,
                        surfaceTintColor: lightThemeColors.colorWhite,
                        modalBarrierColor: lightThemeColors.colorBlack.withValues(alpha: 0.5),
                        elevation: 0,
                        modalElevation: 0,
                      ),
                      // bottomSheetTheme: BottomSheetThemeData(
                      //   backgroundColor:lightThemeColors.colorBlack.withValues(alpha: 0.5),
                      //   modalBackgroundColor: Colors.transparent,
                      //   modalBarrierColor: lightThemeColors.colorBlack.withValues(alpha: 0.5),
                      //   shadowColor: Colors.transparent,
                      //   surfaceTintColor: lightThemeColors.colorWhite,
                      //
                      // ),
                      dialogTheme: DialogThemeData(backgroundColor: lightThemeColors.colorWhite, surfaceTintColor: lightThemeColors.colorWhite),
                      chipTheme: ChipThemeData(
                        showCheckmark: false,
                        backgroundColor: lightThemeColors.colorWhite,
                        surfaceTintColor: lightThemeColors.colorWhite,
                        selectedColor: lightThemeColors.colorPrimary,
                      ),
                      appBarTheme: AppBarTheme(
                        centerTitle: false,
                        titleSpacing: 0,
                        backgroundColor: lightThemeColors.colorAppBarDefault,
                        elevation: 3,
                        shadowColor: const Color(0x33000000),
                        systemOverlayStyle: lightThemeColors.systemUiOverlayStyle,
                        iconTheme: IconThemeData(color: lightThemeColors.colorIconCommon),
                      ),
                      extensions: <ThemeExtension<AppThemeColors>>[lightThemeColors],
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    darkTheme: ThemeData(
                      primaryColor: darkThemeColors.colorPrimary,
                      colorScheme: ThemeData().colorScheme.copyWith(primary: darkThemeColors.colorPrimary, secondary: darkThemeColors.colorPrimary,surface: darkThemeColors.colorScaffoldBg),
                      unselectedWidgetColor: darkThemeColors.colorPrimary,
                      textSelectionTheme: TextSelectionThemeData(cursorColor: darkThemeColors.colorPrimary),
                      fontFamily: GoogleFonts.figtree().fontFamily,
                      scaffoldBackgroundColor: darkThemeColors.colorScaffoldBg,
                      cardTheme: CardThemeData(color: darkThemeColors.colorBlack, surfaceTintColor: darkThemeColors.colorBlack),
                      popupMenuTheme: PopupMenuThemeData(color: getCurrentTheme(context).colorBlack, surfaceTintColor: darkThemeColors.colorBlack),
                      bottomSheetTheme: BottomSheetThemeData(
                        backgroundColor: darkThemeColors.colorBlack,
                        modalBackgroundColor: Colors.transparent,
                        surfaceTintColor: darkThemeColors.colorBlack,
                        modalBarrierColor: darkThemeColors.colorWhite.withValues(alpha: 0.8),
                        elevation: 0,
                        modalElevation: 0,
                      ),
                      dialogTheme: DialogThemeData(backgroundColor: darkThemeColors.colorBlack, surfaceTintColor: darkThemeColors.colorBlack),
                      chipTheme: ChipThemeData(
                        showCheckmark: false,
                        backgroundColor: darkThemeColors.colorBlack,
                        surfaceTintColor: darkThemeColors.colorBlack,
                        selectedColor: darkThemeColors.colorPrimary,
                      ),
                      appBarTheme: AppBarTheme(
                        centerTitle: false,
                        titleSpacing: 0,
                        backgroundColor: darkThemeColors.colorAppBarDefault,
                        elevation: 3,
                        shadowColor: const Color(0x33FFFFFF),
                        systemOverlayStyle: darkThemeColors.systemUiOverlayStyle,
                        iconTheme: IconThemeData(color: darkThemeColors.colorIconCommon),
                      ),
                      extensions: <ThemeExtension<AppThemeColors>>[darkThemeColors],
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    builder: (context, child) {
                      if (AppLocalizations.of(context) != null) {
                        languages = AppLocalizations.of(context)!;
                      }
                      MediaQueryData media = MediaQuery.of(context);
                      TimeOfDayFormat timeOfDayFormat = MaterialLocalizations.of(context).timeOfDayFormat(alwaysUse24HourFormat: media.alwaysUse24HourFormat);
                      isTime24HoursFormat = hourFormat(of: timeOfDayFormat) != HourFormat.h;
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: ScrollConfiguration(behavior: MyBehavior(), child: child ?? Container()),
                      );
                    },
                    locale: selectedLocale,
                    home: const SplashScreen(),
                    supportedLocales: AppLocalizations.supportedLocales,
                    localizationsDelegates: AppLocalizations.localizationsDelegates,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

@pragma('vm:entry-point')
void backgroundCallback() {
  BackgroundLocationTrackerManager.handleBackgroundUpdated((data) async {
    await myLocationCallbackRepository.callback(data);
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage notification) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  localTimeZone = (await FlutterTimezone.getLocalTimezone()).identifier;
  tz.initializeTimeZones();
  Map<String, dynamic> notificationData = notification.data;
  debugPrint("firebaseMessagingBackgroundHandler >>>>>> $notificationData");
  if (notificationData.isNotEmpty) {
    await PushNotificationService.displayBackgroundNotification(notificationData);
  }
  int notificationType = int.parse((notificationData[NotificationConstant.notificationType] ?? 0).toString());
  if (notificationType == 7) {
    await reloadSharedPreference();
    await setPrefNotificationData(NotificationPojo.fromJson(notificationData), tag: "Notification");

    Future.delayed(const Duration(seconds: 30), () {
      setPrefNotificationData(null, tag: "Notification");
    });
    if (Platform.isAndroid && (int.parse(await getAndroidVersion()) < androidVersion15)) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final appCheck = AppCheck();
      await appCheck.launchApp(packageInfo.packageName);
      pushNotificationService.flutterLocalNotificationsPlugin.cancelAll();
    }
  }
}
