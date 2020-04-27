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

    var closeToDashboardCalled = false
    var routeToRootViewControllerCalled = false
    var routeToPaymentMethodCalled = false

    func closeToDashboard() {
        closeToDashboardCalled = true
    }
    func routeToRootViewController() {
        routeToRootViewControllerCalled = true
    }
    func routeToPaymentMethod() {
        routeToPaymentMethodCalled = true
    }
}
