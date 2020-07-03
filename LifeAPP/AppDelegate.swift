//
//  AppDelegate.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/5/25.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase
import Fabric
import FirebaseFirestore
import FirebaseCore
import CoreLocation



let screen = UIScreen.main.bounds.size
let screenScaleWidth = screen.width / 414
let screenSceleHeight = screen.height / 736

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var myLocationManager : CLLocationManager = CLLocationManager()
    var myUserDefaults : UserDefaults!
    let userLocationAuth : String = "locationAuth"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.myUserDefaults = UserDefaults.standard
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.startUpdatingHeading()
        
        
        // 連線至 Firebase
        FirebaseApp.configure()
        
        // 上傳 Debug 至 Firebase
        Fabric.sharedSDK().debug = true
        
        // Set Firebase messaging delegate
        Messaging.messaging().delegate = self
        
        // show the dialog at a more appropriate time move this registration accordingly.
        UNUserNotificationCenter.current().delegate = self
        
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (state, error) in}
//        application.registerForRemoteNotifications()

        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (state, error) in

          }
        } else {
          let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        
        let navigationController = UINavigationController()
        let navigationBar = navigationController.navigationBar
        UINavigationBar.appearance().tintColor = .white
        
        if #available(iOS 13.0, *) {
            let navigationBarAppearence = UINavigationBarAppearance()
            navigationBarAppearence.shadowColor = .clear
            navigationBar.scrollEdgeAppearance = navigationBarAppearence
        } else {
            let image = UIImage()
            navigationController.navigationBar.setBackgroundImage(image, for: .default)
            navigationController.navigationBar.shadowImage = image
        }
        

        if #available(iOS 13.0, *) {
            let statusBar : UIView = UIView.init(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.init(x: 0, y: 0, width: screen.width, height: 20))
            statusBar.backgroundColor = .clear
            UIApplication.shared.keyWindow?.addSubview(statusBar)
            
        } else {
            // Fallback on earlier versions
            let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
            let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = .clear
            }
        }
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var tokenString = ""
        for byte in deviceToken {
            let hexString = String(format: "%02x", byte)
            tokenString += hexString
        }
    }


}

@available(iOS 10,*)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    let userInfo = notification.request.content.userInfo
    print("willPresent userInfo: \(userInfo)")
        
    completionHandler([.badge, .sound, .alert])
  }
    
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    let userInfo = response.notification.request.content.userInfo
    print("didPresent userInfo: \(userInfo)")
        
    completionHandler()
  }
}

extension AppDelegate: MessagingDelegate {
    
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
        
    let dataDict:[String: String] = ["token": fcmToken]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
  }
    
  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    print("Received data message: \(remoteMessage.appData)")
  }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined{
            myLocationManager.requestWhenInUseAuthorization()
        }//if
        else if status == .denied || status == .restricted {
            self.myUserDefaults.set(false, forKey: userLocationAuth)
            self.myUserDefaults.synchronize()
          //這邊可以設定你想要執行的功能，例如這邊我想要紀錄使用者的權限狀況，所以用了userDefaults的功能。
          //如果你沒有想要執行任何功能，else if 這一段這一段可以完全不寫。
        }//else if
        else if status == .authorizedWhenInUse {
            self.myUserDefaults.set(true, forKey: userLocationAuth)
            self.myUserDefaults.synchronize()
          //這一段同上，如果你沒有想要執行任何功能，這一段可以不寫
          //
        }//else if
    }
}
