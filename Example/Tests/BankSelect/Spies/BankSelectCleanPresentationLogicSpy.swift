//
//  BankSelectCleanPresentationLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class BankSelectCleanPresentationLogicSpy: BankSelectCleanPresentationLogic {

    var presentSetUpUICalled = false
    var presentLoadingViewCalled = false
    var hideLoadingViewCalled = false
    var presentBankSelectsCalled = false
    var presentErrorAlertCalled = false
    var presentCuotasCalled = false

    var presentSetUpUIResponse: BankSelectClean.Texts.Response?
    var presentBankSelectsResponse: BankSelectClean.BankSelect.Response.Success?
    var presentErrorAlertResponse: BankSelectClean.BankSelect.Response.Failure?

    func presentSetUpUI(response: BankSelectClean.Texts.Response) {
        presentSetUpUICalled = true
        presentSetUpUIResponse = response
    }
    func presentLoadingView() {
        presentLoadingViewCalled = true
    }
    func hideLoadingView() {
        hideLoadingViewCalled = true
    }
    func presentBankSelects(response: BankSelectClean.BankSelect.Response.Success) {
        presentBankSelectsCalled = true
        presentBankSelectsResponse = response
    }
    func presentErrorAlert(response: BankSelectClean.BankSelect.Response.Failure) {
        presentErrorAlertCalled = true
        presentErrorAlertResponse = response
    }
    func presentCuotas() {
        presentCuotasCalled = true
    }
}
