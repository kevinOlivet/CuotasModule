//
//  PaymentMethodCleanPresentationLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class PaymentMethodCleanPresentationLogicSpy: PaymentMethodCleanPresentationLogic {

    var presentSetupUICalled = false
    var presentLoadingViewCalled = false
    var hideLoadingViewCalled = false
    var presentErrorAlertCalled = false
    var presentPaymentMethodsCalled = false
    var showBankSelectCalled = false
    var presentAmountErrorAlertCalled = false

    var presentSetupUIResponse: PaymentMethodClean.Texts.Response?
    var presentErrorAlertResponse: PaymentMethodClean.PaymentMethodsDetails.Response.Failure?
    var presentPaymentMethodsResponse: PaymentMethodClean.PaymentMethods.Response?
    var showBankSelectResponse: PaymentMethodClean.PaymentMethodsDetails.Response.Success?
    var presentAmountErrorAlertResponse: PaymentMethodClean.PaymentMethodsDetails.Response.AmountFailure?

    func presentSetupUI(response: PaymentMethodClean.Texts.Response) {
        presentSetupUICalled = true
        presentSetupUIResponse = response
    }
    func presentLoadingView() {
        presentLoadingViewCalled = true
    }
    func hideLoadingView() {
        hideLoadingViewCalled = true
    }
    func presentErrorAlert(response: PaymentMethodClean.PaymentMethodsDetails.Response.Failure) {
        presentErrorAlertCalled = true
        presentErrorAlertResponse = response
    }
    func presentAmountErrorAlert(response: PaymentMethodClean.PaymentMethodsDetails.Response.AmountFailure) {
        presentAmountErrorAlertCalled = true
        presentAmountErrorAlertResponse = response
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
