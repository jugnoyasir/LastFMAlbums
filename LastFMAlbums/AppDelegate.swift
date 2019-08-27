//
//  AppDelegate.swift
//  FavAlbumsLastFM
//
//  Created by Yasir Perwez on 21/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    
    let vc = MainViewController.makeFromStoryboard(viewModel: MainViewModel(), transition: ViewControllTransitionAnimation() )
    window?.rootViewController = UINavigationController(rootViewController: vc)

    window?.makeKeyAndVisible()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
  }
}
