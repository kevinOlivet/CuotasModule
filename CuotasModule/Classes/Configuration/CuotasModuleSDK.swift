//
//  CuotasModuleSDK.swift
//  CuotasModule
//
//  Created by Kevin Olivet on 04-01-21.
//

import Foundation

final class CuotasModuleSDK {
    static let resourceBundle: Bundle = {
        let myBundle = Bundle(for: CuotasModuleSDK.self)

        guard let resourceBundleURL = myBundle.url(
            forResource: "CuotasModule", withExtension: "bundle")
            else { fatalError("CuotasModule.bundle not found!") }

        guard let resourceBundle = Bundle(url: resourceBundleURL)
            else { fatalError("Cannot access CuotasModule.bundle!") }

        return resourceBundle
    }()
}
