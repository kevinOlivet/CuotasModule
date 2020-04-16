//
//  EnterAmountCleanDisplayLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class EnterAmountCleanDisplayLogicSpy: EnterAmountCleanDisplayLogic {

    var displaySetUpUICalled = false
    var catchCuotaCalled = false
    var displayTextFieldWithRegexNumberCalled = false
    var showPaymentMethodCalled = false
    var displayCatchCuotaAlertCalled = false
    var displayInputAlertCalled = false

    var displaySetUpUIViewModel: EnterAmountClean.Texts.ViewModel?
    var catchCuotaNotification: Notification?
    var displayTextFieldWithRegexNumberViewModel: EnterAmountClean.Regex.ViewModel?
    var displayCatchCuotaAlertViewModel: EnterAmountClean.CatchNotification.ViewModel?
    var displayInputAlertViewModel: EnterAmountClean.Errors.ViewModel?

    func displaySetUpUI(viewModel: EnterAmountClean.Texts.ViewModel) {
        displaySetUpUICalled = true
        displaySetUpUIViewModel = viewModel
    }
    func catchCuota(notification: Notification) {
        catchCuotaCalled = true
        catchCuotaNotification = notification
    }
    func displayTextFieldWithRegexNumber(viewModel: EnterAmountClean.Regex.ViewModel) {
        displayTextFieldWithRegexNumberCalled = true
        displayTextFieldWithRegexNumberViewModel = viewModel
    }
    func showPaymentMethod() {
        showPaymentMethodCalled = true
    }
    func displayCatchCuotaAlert(viewModel: EnterAmountClean.CatchNotification.ViewModel) {
        displayCatchCuotaAlertCalled = true
        displayCatchCuotaAlertViewModel = viewModel
    }
    func displayInputAlert(viewModel: EnterAmountClean.Errors.ViewModel) {
        displayInputAlertCalled = true
        displayInputAlertViewModel = viewModel
    }
}
