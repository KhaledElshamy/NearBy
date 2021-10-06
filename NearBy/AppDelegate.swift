//
//  AppDelegate.swift
//  NearBy
//
//  Created by Khaled Elshamy on 05/10/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window?.makeKeyAndVisible()
        window?.rootViewController = NearByPlacesViewController()
        return true
    }

}

