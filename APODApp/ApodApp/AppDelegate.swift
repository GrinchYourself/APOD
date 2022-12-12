//
//  AppDelegate.swift
//  ApodApp
//
//  Created by Grinch on 12/12/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()

        return true
    }

}

