//
//  EnterAmountCleanPresenter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol EnterAmountCleanPresentationLogic {
    func setTextFieldWithRegexNumber(numberToUse: String)
    func showPaymentMethod(amountEntered: Int)
    func presentEnterAmountAlert(response: EnterAmountClean.EnterAmount.Response.Error)
    func presentCatchCuotaAlert(response: EnterAmountClean.EnterAmount.Response.Success)
    func presentNumberToUseAlert(response: EnterAmountClean.EnterAmount.Response.Error)
}

class EnterAmountCleanPresenter: EnterAmountCleanPresentationLogic {
    
    weak var viewController: EnterAmountCleanDisplayLogic?
    
    // MARK: Do something
    
    func setTextFieldWithRegexNumber(numberToUse: String) {
        viewController?.setTextFieldWithRegexNumber(numberToUse: numberToUse)
    }
    
    func showPaymentMethod(amountEntered: Int) {
        viewController?.showPaymentMethod(amountEntered: amountEntered)
    }
    
    func presentEnterAmountAlert(response: EnterAmountClean.EnterAmount.Response.Error) {
        let viewModel = EnterAmountClean.EnterAmount.ViewModel.Failure(
            errorTitle: response.errorTitle,
            errorMessage: response.errorMessage,
            buttonTitle: response.buttonTitle
        )
        viewController?.displayEnterAmountAlert(viewModel: viewModel)
    }
    
    func presentCatchCuotaAlert(response: EnterAmountClean.EnterAmount.Response.Success) {
        let viewModel = EnterAmountClean.EnterAmount.ViewModel.TotalSuccess(
            successTitle: response.successTitle,
            successMessage: response.successMessage,
            buttonTitle: response.buttonTitle
        )
        viewController?.displayCatchCuotaAlert(viewModel: viewModel)
    }
    
    func presentNumberToUseAlert(response: EnterAmountClean.EnterAmount.Response.Error) {
        let viewModel = EnterAmountClean.EnterAmount.ViewModel.Failure(
            errorTitle: response.errorTitle,
            errorMessage: response.errorMessage,
            buttonTitle: response.buttonTitle
        )
        viewController?.displayNumberToUseAlert(viewModel: viewModel)
    }

}
