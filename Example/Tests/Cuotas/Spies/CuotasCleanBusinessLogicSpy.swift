//
//  CuotasCleanBusinessLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class CuotasCleanBusinessLogicSpy: CuotasCleanBusinessLogic, CuotasCleanDataStore {

    var amountEntered: Int! = 1234
    var selectedPaymentMethod: PaymentMethodModel!
    var bankSelected: BankSelectModel?
    var cuotasModelArray: [CuotasResult.PayerCost]?

    var prepareSetUpUICalled = false
    var getCuotasCalled = false
    var handleDidSelectRowCalled = false

    var prepareSetUpUIRequest: CuotasClean.Texts.Request?
    var handleDidSelectRowRequest: CuotasClean.CuotasDetails.Request?

    func prepareSetUpUI(request: CuotasClean.Texts.Request) {
        prepareSetUpUICalled = true
        prepareSetUpUIRequest = request
    }
    func getCuotas() {
        getCuotasCalled = true
    }
    func handleDidSelectRow(request: CuotasClean.CuotasDetails.Request) {
        handleDidSelectRowCalled = true
        handleDidSelectRowRequest = request
    }
}
