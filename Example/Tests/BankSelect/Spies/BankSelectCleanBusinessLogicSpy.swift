//
//  BankSelectCleanBusinessLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class BankSelectCleanBusinessLogicSpy: BankSelectCleanBusinessLogic, BankSelectCleanDataStore {

    var amountEntered: Int?
    var selectedPaymentMethod: PaymentMethodModel!
    var bankSelectModelArray: [BankSelectModel] = []
    var selectedBankSelect: BankSelectModel?

    var prepareSetUpUICalled = false
    var getBankSelectCalled = false
    var handleDidSelectItemCalled = false

    var prepareSetUpUIRequest: BankSelectClean.Texts.Request?
    var getBankSelectRequest: BankSelectClean.BankSelect.Request?
    var handleDidSelectItemRequest: BankSelectClean.BankSelectDetails.Request?

    func prepareSetUpUI(request: BankSelectClean.Texts.Request) {
        prepareSetUpUICalled = true
        prepareSetUpUIRequest = request
    }
    func getBankSelect(request: BankSelectClean.BankSelect.Request) {
        getBankSelectCalled = true
        getBankSelectRequest = request
    }
    func handleDidSelectItem(request: BankSelectClean.BankSelectDetails.Request) {
        handleDidSelectItemCalled = true
        handleDidSelectItemRequest = request
    }
}
