//
//  AppDelegate.swift
//  SwiftAVFCIDetector
//
//  Created by Yoshizawa Minoru on 2016/06/21.
//  Copyright © 2016年 Yoshizawa Minoru. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var detectPosition_x:CGFloat?
    var detectPosition_y:CGFloat?
    var tagButtonSize_x:CGFloat?
    var tagButtonSize_y:CGFloat?
    var detectFaceImageSize:CGSize?
    var faceCount:Int?
    var matchingUser:UserData?
    var leftEyePositionData:CGPoint?
    var rightEyePositionData:CGPoint?
    var mouthPositionData:CGPoint?
    var faceSizeHeight:CGFloat?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // first time to launch this app
        let defaults = UserDefaults.standard
        var dic = ["firstLaunch": true]
        defaults.register(defaults: dic)
        
//        // ページを格納する配列
//        var viewControllers: [UIViewController] = []
//        
//        // 1ページ目になるViewController
//        let firstVC = ViewController()
//        firstVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
//        viewControllers.append(firstVC)
//        
//        // 2ページ目になるViewController
//        let secondVC = ProfileViewController()
//        secondVC.tabBarItem = UITabBarItem(title: "Page 2", image: nil, tag: 2)
//        viewControllers.append(secondVC)
//        
//        // ページをセット
//        let tabBarController = UITabBarController()
//        tabBarController.setViewControllers(viewControllers, animated: false)
        
//        // ルートを UITabBarController にする
        //window = UIWindow(frame: UIScreen.main.bounds)
        //window?.backgroundColor = UIColor.white
        //window?.rootViewController = tabBarController
        //window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

