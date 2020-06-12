//
//  AppDelegate.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/5/25.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import GoogleMobileAds


let screen = UIScreen.main.bounds.size
let screenScaleWidth = screen.width / 414
let screenSceleHeight = screen.height / 736

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
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
            statusBar.backgroundColor = .white
            UIApplication.shared.keyWindow?.addSubview(statusBar)
            
        } else {
            // Fallback on earlier versions
            let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
            let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = .white
            }
        }
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
//        // 先建立 Main SB
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let initVC = sb.instantiateViewController(withIdentifier: "main")
//        let nav = UINavigationController(rootViewController: initVC)
//
//        // window 滿版
//        window = UIWindow(frame: UIScreen.main.bounds)
//        // 指定 rootViewController
//        window?.rootViewController = nav
//        // 顯示當前窗口(將 UIWindow 設置可見的)
//        window?.makeKeyAndVisible()
        
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


}
