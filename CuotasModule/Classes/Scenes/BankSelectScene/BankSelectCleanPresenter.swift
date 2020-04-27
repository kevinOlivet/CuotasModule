//
//  BankSelectCleanPresenter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol BankSelectCleanPresentationLogic {
    func presentSetUpUI(response: BankSelectClean.Texts.Response)
    func presentLoadingView()
    func hideLoadingView()
    func presentBankSelects(response: BankSelectClean.BankSelect.Response.Success)
    func presentErrorAlert(response: BankSelectClean.BankSelect.Response.Failure)
    func presentCuotas()
}

class BankSelectCleanPresenter: BankSelectCleanPresentationLogic {
    weak var viewController: BankSelectCleanDisplayLogic?
    
    // MARK: Methods
    func presentSetUpUI(response: BankSelectClean.Texts.Response) {
        let viewModel = BankSelectClean.Texts.ViewModel(title: response.title)
        viewController?.displaySetUpUI(viewModel: viewModel)
    }
    
    func presentLoadingView() {
        viewController?.displayLoadingView()
    }
    
    func hideLoadingView() {
        viewController?.hideLoadingView()
    }
    
    func presentBankSelects(response: BankSelectClean.BankSelect.Response.Success) {
        var displayedBankSelect: [BankSelectClean.BankSelect.ViewModel.DisplayBankSelect] = []
        for bankSelect in response.bankSelectArray {
            let displayBank = BankSelectClean.BankSelect.ViewModel.DisplayBankSelect(
                name: bankSelect.name,
                bankId: bankSelect.id,
                secureThumbnail: bankSelect.secureThumbnail
            )
            displayedBankSelect.append(displayBank)
        }
        let viewModel = BankSelectClean.BankSelect.ViewModel.Success(
            bankSelectArray: displayedBankSelect,
            selectedPaymentMethod: response.selectedPaymentMethod
        )
        viewController?.displayBankSelects(viewModel: viewModel)
    }
    
    func presentErrorAlert(response: BankSelectClean.BankSelect.Response.Failure) {
        let viewModel = BankSelectClean.BankSelect.ViewModel.Failure(errorType: response.errorType)
        viewController?.displayErrorAlert(viewModel: viewModel)
    }
    
    func presentCuotas() {
        viewController?.showCuotas()
    }
}
