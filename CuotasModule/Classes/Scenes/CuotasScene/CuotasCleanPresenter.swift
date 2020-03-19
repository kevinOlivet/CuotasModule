//
//  CuotasCleanPresenter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol CuotasCleanPresentationLogic {
    func presentSpinner()
    func hideSpinner()
    func presentErrorAlert(response: CuotasClean.Cuotas.Response.Failure)
    func presentCuotas(response: CuotasClean.Cuotas.Response.Success)
}

class CuotasCleanPresenter: CuotasCleanPresentationLogic {
    weak var viewController: CuotasCleanDisplayLogic?
    
    // MARK: Do something
    
    func presentSpinner() {
        viewController?.displaySpinner()
    }
    
    func hideSpinner() {
        viewController?.hideSpinner()
    }
    
    func presentErrorAlert(response: CuotasClean.Cuotas.Response.Failure) {
        let viewModel = CuotasClean.Cuotas.ViewModel.Failure(errorTitle: response.errorTitle,
                                                            errorMessage: response.errorMessage,
                                                            buttonTitle: response.buttonTitle)
        viewController?.displayErrorAlert(viewModel: viewModel)
    }
    
    func presentCuotas(response: CuotasClean.Cuotas.Response.Success) {
        var displayCuotasArray: [CuotasClean.Cuotas.ViewModel.DisplayCuota] = []
        for displayCuota in response.cuotasModelArray {
            let cuota = CuotasClean.Cuotas.ViewModel.DisplayCuota(installments: "Installments: \(String(displayCuota.installments))".localized(),
                                                                  recommendedMessage: displayCuota.recommendedMessage)
            displayCuotasArray.append(cuota)
        }
        let viewModel = CuotasClean.Cuotas.ViewModel.Success(cuotasModelArray: displayCuotasArray)
        viewController?.displayCuotasArray(viewModel: viewModel)
    }
}
