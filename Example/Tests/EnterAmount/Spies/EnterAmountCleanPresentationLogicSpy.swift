//
//  EnterAmountCleanPresentationLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class EnterAmountCleanPresentationLogicSpy: EnterAmountCleanPresentationLogic {

    var presentSetUpUICalled = false
    var presentTextFieldWithRegexNumberCalled = false
    var presentPaymentMethodCalled = false
    var presentCatchCuotaAlertCalled = false
    var presentInputAlertCalled = false

    var presentSetUpUIResponse: EnterAmountClean.Texts.Response?
    var presentTextFieldWithRegexNumberResponse: EnterAmountClean.Regex.Response?
    var presentCatchCuotaAlertResponse: EnterAmountClean.CatchNotification.Response?
    var presentInputAlertResponse: EnterAmountClean.Errors.Response?

    func presentSetUpUI(response: EnterAmountClean.Texts.Response) {
        presentSetUpUICalled = true
        presentSetUpUIResponse = response
    }
    func presentTextFieldWithRegexNumber(response: EnterAmountClean.Regex.Response) {
        presentTextFieldWithRegexNumberCalled = true
        presentTextFieldWithRegexNumberResponse = response
    }
    func presentPaymentMethod() {
        presentPaymentMethodCalled = true
    }
    func presentCatchCuotaAlert(response: EnterAmountClean.CatchNotification.Response) {
        presentCatchCuotaAlertCalled = true
        presentCatchCuotaAlertResponse = response
    }
    func presentInputAlert(response: EnterAmountClean.Errors.Response) {
        presentInputAlertCalled = true
        presentInputAlertResponse = response
    }
}
