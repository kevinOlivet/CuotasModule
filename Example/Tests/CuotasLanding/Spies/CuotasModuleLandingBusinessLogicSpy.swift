//
//  CuotasModuleLandingBusinessLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasModule

class CuotasModuleLandingBusinessLogicSpy: CuotasModuleLandingBusinessLogic {

    var setupUICalled = false
    var setupUIRequest: CuotasModuleLanding.Basic.Request?

    func setupUI(request: CuotasModuleLanding.Basic.Request) {
        setupUICalled = true
        setupUIRequest = request
    }
}
