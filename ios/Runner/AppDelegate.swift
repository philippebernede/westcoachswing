import UIKit
import Flutter
import Firebase
import Purchases

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override init() {
       super.init()
       FirebaseApp.configure()
     }
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      Purchases.debugLogsEnabled=true
      Purchases.configure(withAPIKey: "appl_jqkcQKikPEuNTlZrERvSWMZOWHr")
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
