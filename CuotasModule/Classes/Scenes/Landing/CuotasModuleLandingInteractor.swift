//
//  CuotasModuleLandingInteractor.swift
//  Pods
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

import Foundation

protocol CuotasModuleLandingBusinessLogic {
    func setupUI(request: CuotasModuleLanding.Basic.Request)
}

protocol CuotasModuleLandingDataStore {}

class CuotasModuleLandingInteractor: CuotasModuleLandingBusinessLogic, CuotasModuleLandingDataStore {
    var presenter: CuotasModuleLandingPresentationLogic?
    var worker: CuotasModuleLandingWorker = CuotasModuleLandingWorker()

    // MARK: Methods

    func setupUI(request: CuotasModuleLanding.Basic.Request) {
        let response = CuotasModuleLanding.Basic.Response(
            title: "Welcome to the CuotasModuleLanding page",
            subtitle: "Please tap anywhere to begin"
        )
        presenter?.presentSetupUI(response: response)
    }
}
