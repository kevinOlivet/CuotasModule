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
        // Override point for customization after application launch.
        CuotasModuleStubs().enableStubs()
        return true
    }
}

