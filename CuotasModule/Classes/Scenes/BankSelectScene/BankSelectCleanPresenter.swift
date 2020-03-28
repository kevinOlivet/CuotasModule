//
//  BankSelectCleanPresenter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol BankSelectCleanPresentationLogic {
    //  func presentSomething(response: BankSelectClean.Something.Response)
    func presentSpinner()
    func hideSpinner()
    func presentBankSelects(response: BankSelectClean.BankSelect.Response.Success)
    func presentErrorAlert(response: BankSelectClean.BankSelect.Response.Failure)
    func showCuotas(response: BankSelectClean.BankSelectDetails.Response.Success)
}

class BankSelectCleanPresenter: BankSelectCleanPresentationLogic {
    weak var viewController: BankSelectCleanDisplayLogic?
    
    // MARK: Do something
    
    func presentSpinner() {
        viewController?.displaySpinner()
    }
    
    func hideSpinner() {
        viewController?.hideSpinner()
    }
    
    func presentBankSelects(response: BankSelectClean.BankSelect.Response.Success) {
        var displayedBankSelect: [BankSelectClean.BankSelect.ViewModel.DisplayBankSelect] = []
        for bankSelect in response.bankSelectArray {
            let displayBank = BankSelectClean.BankSelect.ViewModel.DisplayBankSelect(name: bankSelect.name,
                                                                                     bankId: bankSelect.id,
                                                                                     secureThumbnail: bankSelect.secureThumbnail)
            displayedBankSelect.append(displayBank)
        }
        let viewModel = BankSelectClean.BankSelect.ViewModel.Success(bankSelectArray: displayedBankSelect)
        viewController?.displayBankSelects(viewModel: viewModel)
    }
    
    func presentErrorAlert(response: BankSelectClean.BankSelect.Response.Failure) {
        let viewModel = BankSelectClean.BankSelect.ViewModel.Failure(errorTitle: response.errorTitle,
                                                                     errorMessage: response.errorMessage,
                                                                     buttonTitle: response.buttonTitle)
        viewController?.displayErrorAlert(viewModel: viewModel)
    }
    
    func showCuotas(response: BankSelectClean.BankSelectDetails.Response.Success) {
        let viewModel = BankSelectClean.BankSelectDetails.ViewModel.Success(amountEntered: response.amountEntered,
                                                                            selectedPaymentMethod: response.selectedPaymentMethod,
                                                                            bankSelected: response.bankSelected)
        viewController?.showCuotas(viewModel: viewModel)
    }
}
