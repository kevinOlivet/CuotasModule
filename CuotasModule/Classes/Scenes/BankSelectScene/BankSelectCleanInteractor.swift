//
//  BankSelectCleanInteractor.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol BankSelectCleanBusinessLogic {
    func prepareSetUpUI(request: BankSelectClean.Texts.Request)
    func getBankSelect(request: BankSelectClean.BankSelect.Request)
    func handleDidSelectItem(request: BankSelectClean.BankSelectDetails.Request)
}

protocol BankSelectCleanDataStore {
    var amountEntered: Int? { get set }
    var selectedPaymentMethod: PaymentMethodModel! { get set }
    var bankSelectModelArray: [BankSelectModel] { get set }
    var selectedBankSelect: BankSelectModel? { get set }
}

class BankSelectCleanInteractor: BankSelectCleanBusinessLogic, BankSelectCleanDataStore {
    var presenter: BankSelectCleanPresentationLogic?
    var worker: BankSelectCleanWorker? = BankSelectCleanWorker()
    
    var amountEntered: Int?
    var selectedPaymentMethod: PaymentMethodModel!
    
    var bankSelectModelArray = [BankSelectModel]()
    var selectedBankSelect: BankSelectModel?
    
    // MARK: Methods

    func prepareSetUpUI(request: BankSelectClean.Texts.Request) {
        if let selectedPaymentMethod = selectedPaymentMethod {
            let response = BankSelectClean.Texts.Response(title: selectedPaymentMethod.name)
            presenter?.presentSetUpUI(response: response)
        }
    }
    
    func getBankSelect(request: BankSelectClean.BankSelect.Request) {
        guard let selectedPaymentMethod = selectedPaymentMethod else {
            return
        }
        presenter?.presentSpinner()
        
        worker?.getBankSelect(
            selectedPaymentMethodId: selectedPaymentMethod.id,
            successCompletion: { (receivedBankSelectModels) in
                self.presenter?.hideSpinner()
                if let receivedBankSelectModels = receivedBankSelectModels {
                    self.bankSelectModelArray = receivedBankSelectModels
                    let response = BankSelectClean.BankSelect.Response.Success(
                        bankSelectArray: receivedBankSelectModels,
                        selectedPaymentMethod: selectedPaymentMethod
                    )
                    self.presenter?.presentBankSelects(response: response)
                } else {
                    let response = BankSelectClean.BankSelect.Response.Failure(
                        errorTitle: "Error",
                        errorMessage: "Error Parsing",
                        buttonTitle: "Cancel"
                    )
                    self.presenter?.presentErrorAlert(response: response)
                }

        }, failureCompletion: { (error) in
            self.presenter?.hideSpinner()
            let response = BankSelectClean.BankSelect.Response.Failure(
                errorTitle: "Error",
                errorMessage: "Service Error",
                buttonTitle: "Cancel"
            )
            self.presenter?.presentErrorAlert(response: response)
        })
    }
    
    func handleDidSelectItem(request: BankSelectClean.BankSelectDetails.Request) {
        selectedBankSelect = !bankSelectModelArray.isEmpty ? bankSelectModelArray[request.indexPath.row] : nil
        presenter?.presentCuotas()
    }
}
