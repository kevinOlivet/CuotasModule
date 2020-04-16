//
//  CuotasModuleLandingPresentationLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class CuotasModuleLandingPresentationLogicSpy: CuotasModuleLandingPresentationLogic {

    var presentSetupUICalled = false
    var presentSetupUIResponse: CuotasModuleLanding.Basic.Response?

    func presentSetupUI(response: CuotasModuleLanding.Basic.Response) {
        presentSetupUICalled = true
        presentSetupUIResponse = response
    }
}
