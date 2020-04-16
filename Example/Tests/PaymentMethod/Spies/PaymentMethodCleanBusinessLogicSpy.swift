//
//  PaymentMethodCleanBusinessLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class PaymentMethodCleanBusinessLogicSpy:
    PaymentMethodCleanBusinessLogic,
    PaymentMethodCleanDataStore {

    var selectedPaymentMethod: PaymentMethodModel!
    var amountEntered: Int?

    var prepareSetUpUICalled = false
    var fetchPaymentMethodsCalled = false
    var handleDidSelectRowCalled = false

    var prepareSetUpUIRequest: PaymentMethodClean.Texts.Request?
    var fetchPaymentMethodsRequest: PaymentMethodClean.PaymentMethods.Request?
    var handleDidSelectRowRequest: PaymentMethodClean.PaymentMethodsDetails.Request?

    func prepareSetUpUI(request: PaymentMethodClean.Texts.Request) {
        prepareSetUpUICalled = true
        prepareSetUpUIRequest = request
    }
    func fetchPaymentMethods(request: PaymentMethodClean.PaymentMethods.Request) {
        fetchPaymentMethodsCalled = true
        fetchPaymentMethodsRequest = request
    }
    func handleDidSelectRow(request: PaymentMethodClean.PaymentMethodsDetails.Request) {
        handleDidSelectRowCalled = true
        handleDidSelectRowRequest = request
    }
}
