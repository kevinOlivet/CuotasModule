//
//  PaymentMethodCleanPresenter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol PaymentMethodCleanPresentationLogic {
    func presentSetupUI(response: PaymentMethodClean.Texts.Response)
    func presentSpinner()
    func hideSpinner()
    func presentErrorAlert(response: PaymentMethodClean.PaymentMethodsDetails.Response.Failure)
    func presentPaymentMethods(response: PaymentMethodClean.PaymentMethods.Response)
    func showBankSelect(response: PaymentMethodClean.PaymentMethodsDetails.Response.Success)
    func presentWrongAmountAlert(response: PaymentMethodClean.PaymentMethodsDetails.Response.Failure)
}

class PaymentMethodCleanPresenter: PaymentMethodCleanPresentationLogic {
    weak var viewController: PaymentMethodCleanDisplayLogic?
    var paymentMethodArray = [PaymentMethodClean.PaymentMethods.ViewModel.DisplayPaymentMethodViewModelSuccess]()
    
    // MARK: Methods
    func presentSetupUI(response: PaymentMethodClean.Texts.Response) {
        let title = "$\(String(response.title))"
        let viewModel = PaymentMethodClean.Texts.ViewModel(title: title)
        viewController?.displaySetupUI(viewModel: viewModel)
    }
    
    func presentSpinner() {
        viewController?.displaySpinner()
    }
    
    func hideSpinner() {
        viewController?.hideSpinner()
    }
    
    func presentErrorAlert(response: PaymentMethodClean.PaymentMethodsDetails.Response.Failure) {
        let viewModel = PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure(
            errorTitle: response.errorTitle.localized,
            errorMessage: response.errorMessage.localized,
            buttonTitle: response.buttonTitle.localized
        )
        viewController?.displayErrorAlert(viewModel: viewModel)
    }
    
    func presentPaymentMethods(response: PaymentMethodClean.PaymentMethods.Response) {
        for method in response.paymentMethodArray {
            let viewModel = PaymentMethodClean.PaymentMethods.ViewModel.DisplayPaymentMethodViewModelSuccess(
                name: method.name,
                paymentId: method.id,
                secureThumbnail: method.secureThumbnail,
                paymentTypeId: method.paymentTypeId,
                minAllowedAmount: method.minAllowedAmount,
                maxAllowedAmount: method.maxAllowedAmount
            )
            self.paymentMethodArray.append(viewModel)
        }
        let viewModelArray = PaymentMethodClean.PaymentMethods.ViewModel(displayPaymentMethodViewModelArray: paymentMethodArray)
        viewController?.displayPaymentMethodArray(viewModel: viewModelArray)
    }
    
    func showBankSelect(response: PaymentMethodClean.PaymentMethodsDetails.Response.Success) {
        let viewModel = PaymentMethodClean.PaymentMethodsDetails.ViewModel.Success(
            amountEntered: response.amountEntered,
            selectedPaymentMethod: response.selectedPaymentMethod
        )
        viewController?.showBankSelect(viewModel: viewModel)
    }
    
    func presentWrongAmountAlert(response: PaymentMethodClean.PaymentMethodsDetails.Response.Failure) {
        let viewModel = PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure(
            errorTitle: response.errorTitle.localized,
            errorMessage: response.errorMessage.localized,
            buttonTitle: response.buttonTitle.localized
        )
        viewController?.displayWrongAmountAlert(viewModel: viewModel)
    }
}
