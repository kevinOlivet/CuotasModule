//
//  CuotasCleanPresenter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol CuotasCleanPresentationLogic {
    func presentSetUpUI(response: CuotasClean.Texts.Response)
    func presentLoadingView()
    func hideLoadingView()
    func presentErrorAlert(response: CuotasClean.Cuotas.Response.Failure)
    func presentCuotas(response: CuotasClean.Cuotas.Response.Success)
}

class CuotasCleanPresenter: CuotasCleanPresentationLogic {
    weak var viewController: CuotasCleanDisplayLogic?
    
    // MARK: Methods
    func presentSetUpUI(response: CuotasClean.Texts.Response) {
        let viewModel = CuotasClean.Texts.ViewModel(title: response.title)
        viewController?.displaySetUpUI(viewModel: viewModel)
    }

    func presentLoadingView() {
        viewController?.displayLoadingView()
    }
    
    func hideLoadingView() {
        viewController?.hideLoadingView()
    }
    
    func presentErrorAlert(response: CuotasClean.Cuotas.Response.Failure) {
        let viewModel = CuotasClean.Cuotas.ViewModel.Failure(errorType: response.errorType)
        viewController?.displayErrorAlert(viewModel: viewModel)
    }
    
    func presentCuotas(response: CuotasClean.Cuotas.Response.Success) {
        var displayCuotasArray: [CuotasClean.Cuotas.ViewModel.DisplayCuota] = []
        for displayCuota in response.cuotasModelArray {
            let cuota = CuotasClean.Cuotas.ViewModel.DisplayCuota(
                installments: "INSTALLMENTS".localized + "\(String(displayCuota.installments))",
                recommendedMessage: displayCuota.recommendedMessage
            )
            displayCuotasArray.append(cuota)
        }
        let viewModel = CuotasClean.Cuotas.ViewModel.Success(cuotasModelArray: displayCuotasArray)
        viewController?.displayCuotasArray(viewModel: viewModel)
    }
}
