//
//  PaymentMethodCleanPresenter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicUIElements

protocol PaymentMethodCleanPresentationLogic {
    func presentSetupUI(response: PaymentMethodClean.Texts.Response)
    func presentLoadingView()
    func hideLoadingView()
    func presentErrorAlert(response: PaymentMethodClean.PaymentMethodsDetails.Response.Failure)
    func presentAmountErrorAlert(response: PaymentMethodClean.PaymentMethodsDetails.Response.AmountFailure)
    func presentPaymentMethods(response: PaymentMethodClean.PaymentMethods.Response)
    func showBankSelect(response: PaymentMethodClean.PaymentMethodsDetails.Response.Success)
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
    
    func presentLoadingView() {
        viewController?.displayLoadingView()
    }
    
    func hideLoadingView() {
        viewController?.hideLoadingView()
    }
    
    func presentErrorAlert(response: PaymentMethodClean.PaymentMethodsDetails.Response.Failure) {
        let viewModel = PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure(errorType: response.errorType)
        viewController?.displayErrorAlert(viewModel: viewModel)
    }
    func presentAmountErrorAlert(response: PaymentMethodClean.PaymentMethodsDetails.Response.AmountFailure) {
        let viewModel = PaymentMethodClean.PaymentMethodsDetails.ViewModel.AmountFailure(
            errorTitle: response.errorTitle.localized,
            errorMessage: response.errorMessage.localized,
            buttonTitle: response.buttonTitle.localized,
            image: MainAsset.iconCloseBlack.image
        )
        viewController?.displayAmountErrorAlert(viewModel: viewModel)
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
}
