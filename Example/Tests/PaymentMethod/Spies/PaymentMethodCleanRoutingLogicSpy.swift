//
//  PaymentMethodCleanRoutingLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule
import Foundation

class PaymentMethodCleanRoutingLogicSpy: NSObject,
    PaymentMethodCleanRoutingLogic,
    PaymentMethodCleanDataPassing {

    var dataStore: PaymentMethodCleanDataStore?
    var routeToBankSelectCalled = false

    func routeToBankSelect() {
        routeToBankSelectCalled = true
    }
}
