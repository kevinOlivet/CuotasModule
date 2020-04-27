//
//  EnterAmountCleanPresenter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicUIElements

protocol EnterAmountCleanPresentationLogic {
    func presentSetUpUI(response: EnterAmountClean.Texts.Response)
    func presentTextFieldWithRegexNumber(response: EnterAmountClean.Regex.Response)
    func presentPaymentMethod()
    func presentCatchCuotaAlert(response: EnterAmountClean.CatchNotification.Response)
    func presentInputAlert(response: EnterAmountClean.Errors.Response)
}

class EnterAmountCleanPresenter: EnterAmountCleanPresentationLogic {
    
    weak var viewController: EnterAmountCleanDisplayLogic?
    
    // MARK: Methods
    func presentSetUpUI(response: EnterAmountClean.Texts.Response) {
        let viewModel = EnterAmountClean.Texts.ViewModel(
            title: response.title.localized,
            enterAmountLabel: response.enterAmountLabel.localized,
            nextButton: response.nextButton.localized
        )
        viewController?.displaySetUpUI(viewModel: viewModel)
    }
    
    func presentTextFieldWithRegexNumber(response: EnterAmountClean.Regex.Response) {
        let viewModel = EnterAmountClean.Regex.ViewModel(numberToUse: response.numberToUse)
        viewController?.displayTextFieldWithRegexNumber(viewModel: viewModel)
    }
    
    func presentPaymentMethod() {
        viewController?.showPaymentMethod()
    }
    
    func presentCatchCuotaAlert(response: EnterAmountClean.CatchNotification.Response) {
        let viewModel = EnterAmountClean.CatchNotification.ViewModel(
            successTitle: response.successTitle.localized,
            successMessage: response.successMessage.localized,
            buttonTitle: response.buttonTitle.localized
        )
        viewController?.displayCatchCuotaAlert(viewModel: viewModel)
    }
    
    func presentInputAlert(response: EnterAmountClean.Errors.Response) {
        let viewModel = EnterAmountClean.Errors.ViewModel(
            errorTitle: response.errorTitle.localized,
            errorMessage: response.errorMessage.localized,
            buttonTitle: response.buttonTitle.localized,
            image: MainAsset.iconCloseBlack.image
        )
        viewController?.displayInputAlert(viewModel: viewModel)
    }

}
