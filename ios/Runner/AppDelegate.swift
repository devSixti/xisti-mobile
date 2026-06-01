import UIKit
import Flutter
import GoogleMaps
import background_location_tracker
import Firebase
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    override func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Firebase MUST be first
        FirebaseApp.configure()

        // Local notifications background isolate
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback {
            registry in
            GeneratedPluginRegistrant.register(with: registry)
        }

        // Background location tracker isolate
        BackgroundLocationTrackerPlugin.setPluginRegistrantCallback {
            registry in
            GeneratedPluginRegistrant.register(with: registry)
        }

        // Google Maps
        GMSServices.provideAPIKey("AIzaSyCoWZtj82AFUj6uCjoe2k04DQtFS_xfGao")

        // Notification delegate (NO optional cast)
        UNUserNotificationCenter.current().delegate = self

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func userNotificationCenter(_ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        // If it's an FCM notification, let Firebase handle it so onMessage works
        if userInfo["gcm.message_id"] != nil {
            super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
            return
        }

        // Otherwise (like for background_downloader), we handle it to force foreground display
        if #available (iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }
}
