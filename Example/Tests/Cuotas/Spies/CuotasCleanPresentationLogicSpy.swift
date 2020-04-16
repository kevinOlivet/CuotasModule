//
//  CuotasCleanPresentationLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class CuotasCleanPresentationLogicSpy: CuotasCleanPresentationLogic {

    var presentSetUpUICalled = false
    var presentSpinnerCalled = false
    var hideSpinnerCalled = false
    var presentErrorAlertCalled = false
    var presentCuotasCalled = false

    var presentSetUpUIResponse: CuotasClean.Texts.Response?
    var presentErrorAlertResponse: CuotasClean.Cuotas.Response.Failure?
    var presentCuotasResponse: CuotasClean.Cuotas.Response.Success?

    func presentSetUpUI(response: CuotasClean.Texts.Response) {
        presentSetUpUICalled = true
        presentSetUpUIResponse = response
    }
    func presentSpinner() {
        presentSpinnerCalled = true
    }
    func hideSpinner() {
        hideSpinnerCalled = true
    }
    func presentErrorAlert(response: CuotasClean.Cuotas.Response.Failure) {
        presentErrorAlertCalled = true
        presentErrorAlertResponse = response
    }
    func presentCuotas(response: CuotasClean.Cuotas.Response.Success) {
        presentCuotasCalled = true
        presentCuotasResponse = response
    }
}
