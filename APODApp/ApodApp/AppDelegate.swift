//
//  AppDelegate.swift
//  ApodApp
//
//  Created by Grinch on 12/12/2022.
//

import UIKit
import ListingPictures
import Domain
import Repository
import RemoteStore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainCoordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

        let  appearance = Appearance().navigationAppearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        let navigationVC = MainNavigationController()
        let mainCoordinator = MainCoordinator(dependencies: MainDependencies(),
                                              navigationController: navigationVC)

        mainCoordinator.start()
        self.mainCoordinator = mainCoordinator
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()

        return true
    }

}

