//
//  BankSelectCleanInteractor.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol BankSelectCleanBusinessLogic {
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
    
    // MARK: Do something
    
    func getBankSelect(request: BankSelectClean.BankSelect.Request) {
        presenter?.presentSpinner()
        
        worker?.getBankSelect(
            request: request,
            successCompletion: { (receivedBankSelectModels) in
                self.presenter?.hideSpinner()
                if let receivedBankSelectModels = receivedBankSelectModels {
                    self.bankSelectModelArray = receivedBankSelectModels
                    let response = BankSelectClean.BankSelect.Response.Success(
                        bankSelectArray: receivedBankSelectModels,
                        selectedPaymentMethod: self.selectedPaymentMethod
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
        selectedBankSelect = (bankSelectModelArray.count > 0) ? bankSelectModelArray[request.indexPath.row] : nil
        if let amountEntered = amountEntered, let selectedPaymentMethod = selectedPaymentMethod {
            let response = BankSelectClean.BankSelectDetails.Response.Success(
                amountEntered: amountEntered,
                selectedPaymentMethod: selectedPaymentMethod,
                bankSelected: selectedBankSelect
            )
            presenter?.showCuotas(response: response)
        } else {
            let response = BankSelectClean.BankSelect.Response.Failure(
                errorTitle: "Error",
                errorMessage: "Error with amount",
                buttonTitle: "Cancel"
            )
            presenter?.presentErrorAlert(response: response)
        }
        
    }
}
