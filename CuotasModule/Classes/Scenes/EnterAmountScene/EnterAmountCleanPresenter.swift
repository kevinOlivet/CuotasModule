//
//  EnterAmountCleanPresenter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol EnterAmountCleanPresentationLogic {
    func presentSetUpUI(response: EnterAmountClean.Texts.Response)
    func setTextFieldWithRegexNumber(numberToUse: String)
    func showPaymentMethod(amountEntered: Int)

    func presentCatchCuotaAlert(response: EnterAmountClean.EnterAmount.Response.Success)
    func presentInputAlert(response: EnterAmountClean.EnterAmount.Response.Error)
}

class EnterAmountCleanPresenter: EnterAmountCleanPresentationLogic {
    
    weak var viewController: EnterAmountCleanDisplayLogic?
    
    // MARK: Do something
    func presentSetUpUI(response: EnterAmountClean.Texts.Response) {
        let viewModel = EnterAmountClean.Texts.ViewModel(
            title: response.title,
            enterAmountLabel: response.enterAmountLabel.localized,
            nextButton: response.nextButton.localized
        )
        viewController?.displaySetUpUI(viewModel: viewModel)
    }
    
    func setTextFieldWithRegexNumber(numberToUse: String) {
        viewController?.setTextFieldWithRegexNumber(numberToUse: numberToUse)
    }
    
    func showPaymentMethod(amountEntered: Int) {
        viewController?.showPaymentMethod(amountEntered: amountEntered)
    }
    
    func presentCatchCuotaAlert(response: EnterAmountClean.EnterAmount.Response.Success) {
        let viewModel = EnterAmountClean.EnterAmount.ViewModel.TotalSuccess(
            successTitle: response.successTitle.localized,
            successMessage: response.successMessage.localized,
            buttonTitle: response.buttonTitle.localized
        )
        viewController?.displayCatchCuotaAlert(viewModel: viewModel)
    }
    
    func presentInputAlert(response: EnterAmountClean.EnterAmount.Response.Error) {
        let viewModel = EnterAmountClean.EnterAmount.ViewModel.Failure(
            errorTitle: response.errorTitle.localized,
            errorMessage: response.errorMessage.localized,
            buttonTitle: response.buttonTitle.localized
        )
        viewController?.displayInputAlert(viewModel: viewModel)
    }

}
