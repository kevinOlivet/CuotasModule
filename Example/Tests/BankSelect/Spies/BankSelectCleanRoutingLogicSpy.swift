//
//  BankSelectCleanRoutingLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule
import Foundation

class BankSelectCleanRoutingLogicSpy: NSObject, BankSelectCleanRoutingLogic, BankSelectCleanDataPassing {

    var dataStore: BankSelectCleanDataStore?
    var routeToCuotasCalled = false

    func routeToCuotas() {
        routeToCuotasCalled = true
    }
}
