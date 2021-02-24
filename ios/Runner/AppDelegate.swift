import UIKit
import Flutter
import Firebase
import flutter_background_service

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    static func registerPlugins(with registry: FlutterPluginRegistry) {
           GeneratedPluginRegistrant.register(with: registry)
       }
       
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        FirebaseApp.configure() // FIRST LINE!
        GeneratedPluginRegistrant.register(with: self) // SECOND LINE!
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
