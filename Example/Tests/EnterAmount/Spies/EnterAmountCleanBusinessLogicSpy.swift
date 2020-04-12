//
//  EnterAmountCleanBusinessLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class EnterAmountCleanBusinessLogicSpy: EnterAmountCleanBusinessLogic {

    var prepareSetUpUICalled = false
    var handleNextButtonTappedCalled = false
    var catchCuotaCalled = false

    var prepareSetUpUIRequst: EnterAmountClean.Texts.Request?
    var handleNextButtonTappedRequst: EnterAmountClean.EnterAmount.Request?
    var catchCuotaRequst: EnterAmountClean.CatchNotification.Request?

    func prepareSetUpUI(request: EnterAmountClean.Texts.Request) {
        prepareSetUpUICalled = true
        prepareSetUpUIRequst = request
    }
    func handleNextButtonTapped(request: EnterAmountClean.EnterAmount.Request) {
        handleNextButtonTappedCalled = true
        handleNextButtonTappedRequst = request
    }
    func catchCuota(request: EnterAmountClean.CatchNotification.Request) {
        catchCuotaCalled = true
        catchCuotaRequst = request
    }
}
