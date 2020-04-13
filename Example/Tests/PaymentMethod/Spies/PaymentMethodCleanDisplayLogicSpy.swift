//
//  PaymentMethodCleanDisplayLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class PaymentMethodCleanDisplayLogicSpy: PaymentMethodCleanDisplayLogic {

    var displaySetupUICalled = false
    var displaySpinnerCalled = false
    var hideSpinnerCalled = false
    var displayErrorAlertCalled = false
    var displayPaymentMethodArrayCalled = false
    var showBankSelectCalled = false

    var displaySetupUIViewModel: PaymentMethodClean.Texts.ViewModel?
    var displayErrorAlertViewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure?
    var displayPaymentMethodArrayViewModel: PaymentMethodClean.PaymentMethods.ViewModel?
    var showBankSelectViewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Success?

    func displaySetupUI(viewModel: PaymentMethodClean.Texts.ViewModel) {
        displaySetupUICalled = true
        displaySetupUIViewModel = viewModel
    }
    func displaySpinner() {
        displaySpinnerCalled = true
    }
    func hideSpinner() {
        hideSpinnerCalled = true
    }
    func displayErrorAlert(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure) {
        displayErrorAlertCalled = true
        displayErrorAlertViewModel = viewModel
    }
    func displayPaymentMethodArray(viewModel: PaymentMethodClean.PaymentMethods.ViewModel) {
        displayPaymentMethodArrayCalled = true
        displayPaymentMethodArrayViewModel = viewModel
    }
    func showBankSelect(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Success) {
        showBankSelectCalled = true
        showBankSelectViewModel = viewModel
    }
}
