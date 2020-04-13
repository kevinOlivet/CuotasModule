//
//  PaymentMethodCleanPresentationLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class PaymentMethodCleanPresentationLogicSpy: PaymentMethodCleanPresentationLogic {

    var presentSetupUICalled = false
    var presentSpinnerCalled = false
    var hideSpinnerCalled = false
    var presentErrorAlertCalled = false
    var presentPaymentMethodsCalled = false
    var showBankSelectCalled = false

    var presentSetupUIResponse: PaymentMethodClean.Texts.Response?
    var presentErrorAlertResponse: PaymentMethodClean.PaymentMethodsDetails.Response.Failure?
    var presentPaymentMethodsResponse: PaymentMethodClean.PaymentMethods.Response?
    var showBankSelectResponse: PaymentMethodClean.PaymentMethodsDetails.Response.Success?

    func presentSetupUI(response: PaymentMethodClean.Texts.Response) {
        presentSetupUICalled = true
        presentSetupUIResponse = response
    }
    func presentSpinner() {
        presentSpinnerCalled = true
    }
    func hideSpinner() {
        hideSpinnerCalled = true
    }
    func presentErrorAlert(response: PaymentMethodClean.PaymentMethodsDetails.Response.Failure) {
        presentErrorAlertCalled = true
        presentErrorAlertResponse = response
    }
    func presentPaymentMethods(response: PaymentMethodClean.PaymentMethods.Response) {
        presentPaymentMethodsCalled = true
        presentPaymentMethodsResponse = response
    }
    func showBankSelect(response: PaymentMethodClean.PaymentMethodsDetails.Response.Success) {
        showBankSelectCalled = true
        showBankSelectResponse = response
    }
}
