import UIKit
import SwiftUI
import ARKit
import Mixpanel

@main
struct StudioFrameApp: App {
    
  

    //@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    
}

//class AppDelegate: NSObject, UIApplicationDelegate {
    //func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
    
        //guard ARWorldTrackingConfiguration.isSupported else {
        //    fatalError("""
        //        ARKit is not available on this device. For apps that require ARKit
        //        for core functionality, use the `arkit` key in the
        //        `UIRequiredDeviceCapabilities` section of the Info.plist, which will prevent
        //        the app from installing. (If the app can't be installed, this error
        //        can't be triggered in a production scenario.)
        //        In apps where AR is an additive feature, use `isSupported` to
        //        determine whether to show UI for launching AR experiences.
        //    """) // For details, see https://developer.apple.com/documentation/arkit
        //}
//
        //guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) else {
        //    fatalError("""
        //        Scene reconstruction requires a device with a LiDAR Scanner, such as the 4th-Gen iPad Pro.
        //    """)
        //}
        
//        var configuration = ARWorldTrackingConfiguration()
//        
//        configuration.planeDetection = [.horizontal, .vertical]
//        
        
        //return true
    //}
    
        
//}
