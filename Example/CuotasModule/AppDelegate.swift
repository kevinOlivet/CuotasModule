//
//  AppDelegate.swift
//  CuotasModule
//
//  Created by Jon Olivet on 03/17/2020.
//  Copyright (c) 2020 Jon Olivet. All rights reserved.
//

import CuotasModule
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch and to enableStubs
        #if DEBUG
        CuotasModuleStubs().enableStubs()
        #endif

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let viewController = CuotasModuleFactory().getExampleRootViewController()
        window?.rootViewController = viewController
        return true
    }
}

