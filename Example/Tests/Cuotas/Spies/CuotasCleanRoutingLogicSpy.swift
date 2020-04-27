//
//  CuotasCleanRoutingLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule
import Foundation

class CuotasCleanRoutingLogicSpy: NSObject, CuotasCleanRoutingLogic, CuotasCleanDataPassing {

    var dataStore: CuotasCleanDataStore?

    var closeToDashboardCalled = false

    func closeToDashboard() {
        closeToDashboardCalled = true
    }
}
