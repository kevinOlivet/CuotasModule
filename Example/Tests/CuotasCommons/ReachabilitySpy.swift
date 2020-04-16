//
//  ReachabilitySpy.swift
//  CuotasModule_Tests
//
//  Created by Jon Olivet on 4/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import BasicCommons

class ReachabilitySpy: ReachabilityCheckingProtocol {

    var isConnectedToNetworkCalled = false

    var isConnectedToNetworkReturnValue = true

    func isConnectedToNetwork() -> Bool {
        isConnectedToNetworkCalled = true
        return isConnectedToNetworkReturnValue
    }
}
