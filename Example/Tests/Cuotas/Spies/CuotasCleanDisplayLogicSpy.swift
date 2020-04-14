//
//  CuotasCleanDisplayLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class CuotasCleanDisplayLogicSpy: CuotasCleanDisplayLogic {

    var displaySetUpUICalled = false
    var displaySpinnerCalled = false
    var hideSpinnerCalled = false
    var displayErrorAlertCalled = false
    var displayCuotasArrayCalled = false

    var displaySetUpUIViewModel: CuotasClean.Texts.ViewModel?
    var displayErrorAlertViewModel: CuotasClean.Cuotas.ViewModel.Failure?
    var displayCuotasArrayViewModel: CuotasClean.Cuotas.ViewModel.Success?

    func displaySetUpUI(viewModel: CuotasClean.Texts.ViewModel) {
        displaySetUpUICalled = true
        displaySetUpUIViewModel = viewModel
    }
    func displaySpinner() {
        displaySpinnerCalled = true
    }
    func hideSpinner() {
        hideSpinnerCalled = true
    }
    func displayErrorAlert(viewModel: CuotasClean.Cuotas.ViewModel.Failure) {
        displayErrorAlertCalled = true
        displayErrorAlertViewModel = viewModel
    }
    func displayCuotasArray(viewModel: CuotasClean.Cuotas.ViewModel.Success) {
        displayCuotasArrayCalled = true
        displayCuotasArrayViewModel = viewModel
    }
}
