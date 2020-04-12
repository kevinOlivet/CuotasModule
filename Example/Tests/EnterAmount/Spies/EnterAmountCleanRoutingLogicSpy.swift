//
//  EnterAmountCleanRoutingLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule
import Foundation

class EnterAmountCleanRoutingLogicSpy: NSObject,
    EnterAmountCleanRoutingLogic,
    EnterAmountCleanDataPassing {

    var dataStore: EnterAmountCleanDataStore?

    var routeToRootViewControllerCalled = false
    var routeToPaymentMethodCalled = false

    func routeToRootViewController() {
        routeToRootViewControllerCalled = true
    }
    func routeToPaymentMethod() {
        routeToPaymentMethodCalled = true
    }
}
