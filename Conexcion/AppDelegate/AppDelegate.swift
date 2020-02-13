//
//  AppDelegate.swift
//  Conexcion
//
//  Created by admin on 03/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MBProgressHUD
import UserNotifications
import LGSideMenuController
import TTGSnackbar
import GoogleSignIn
import FBSDKLoginKit
import MGStarRatingView


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.applicationSetting(application: application)
        UINavigationBar.appearance().tintColor = .black
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 30.0
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.placeholderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_KEY
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    private func applicationSetting(application :UIApplication) {
        if "\(UserDefaults_FindData(keyName: kDeviceToken))" == "" {
            UserDefaults_SaveData(dictData: DEFAULT_TOKEN, keyName: kDeviceToken)
        }
        //-----Notificatiom premision------
        // registerRemotNotification()
    }
    //MARK Call back
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]) {
            return true
        }
        
        let sourceApplication: String? = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        return ApplicationDelegate.shared.application(app, open: url, sourceApplication: sourceApplication, annotation: nil)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

//MARK: UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    //-----Notificatiom premision------
    func registerRemotNotification() {
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            UIApplication.shared.registerForRemoteNotifications()
        } else {// iOS 7,8,9 support
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
            UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
    }
    
    func getNotificationSettings()  {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
                
                switch setttings.soundSetting{
                case .enabled:
                    print("Enabled notification sound setting")
                    
                case .disabled:
                    print("Notification setting has been disabled")
                    
                case .notSupported:
                    print("something vital went wrong here")
                }
            }
        }
    }
    
    //MARK APNS Delegate methode
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        UserDefaults_SaveData(dictData: deviceTokenString, keyName: kDeviceToken)
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    
    
    //MARK APNS Delegate methode
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        handelNotidata(userInfo: userInfo as NSDictionary)
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let dictApsData : NSDictionary = response.notification.request.content.userInfo as NSDictionary
        // print(dictApsData)
        handelNotidata(userInfo: dictApsData)
    }
    
    
    func handelNotidata(userInfo :NSDictionary  )  {
        
        print(userInfo)
        let state: UIApplication.State = UIApplication.shared.applicationState
        
        var hostVC = UIApplication.shared.keyWindow?.rootViewController
        while let next = hostVC?.presentedViewController {
            hostVC = next
        }
        
        if userInfo["data"] != nil {
            switch state {
            case .active:
                break
            case .background:
                break
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }
}
extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
