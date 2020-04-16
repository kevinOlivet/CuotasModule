//
//  CuotasModuleLandingDisplayLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class CuotasModuleLandingDisplayLogicSpy: CuotasModuleLandingDisplayLogic {

    var displaySetupUICalled = false
    var displaySetupUIViewModel: CuotasModuleLanding.Basic.ViewModel?

    func displaySetupUI(viewModel: CuotasModuleLanding.Basic.ViewModel) {
        displaySetupUICalled = true
        displaySetupUIViewModel = viewModel
    }
}
