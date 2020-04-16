//
//  BankSelectCleanDisplayLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class BankSelectCleanDisplayLogicSpy: BankSelectCleanDisplayLogic {

    var displaySetUpUICalled = false
    var displaySpinnerCalled = false
    var hideSpinnerCalled = false
    var fetchBankSelectCalled = false
    var displayBankSelectsCalled = false
    var displayErrorAlertCalled = false
    var showCuotasCalled = false

    var displaySetUpUIViewModel: BankSelectClean.Texts.ViewModel?
    var displayBankSelectsViewModel: BankSelectClean.BankSelect.ViewModel.Success?
    var displayErrorAlertViewModel: BankSelectClean.BankSelect.ViewModel.Failure?

    func displaySetUpUI(viewModel: BankSelectClean.Texts.ViewModel) {
        displaySetUpUICalled = true
        displaySetUpUIViewModel = viewModel
    }
    func displaySpinner() {
        displaySpinnerCalled = true
    }
    func hideSpinner() {
        hideSpinnerCalled = true
    }
    func fetchBankSelect() {
        fetchBankSelectCalled = true
    }
    func displayBankSelects(viewModel: BankSelectClean.BankSelect.ViewModel.Success) {
        displayBankSelectsCalled = true
        displayBankSelectsViewModel = viewModel
    }
    func displayErrorAlert(viewModel: BankSelectClean.BankSelect.ViewModel.Failure) {
        displayErrorAlertCalled = true
        displayErrorAlertViewModel = viewModel
    }
    func showCuotas() {
        showCuotasCalled = true
    }
}
