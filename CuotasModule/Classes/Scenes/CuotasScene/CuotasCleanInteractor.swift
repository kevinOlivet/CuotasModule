//
//  CuotasCleanInteractor.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol CuotasCleanBusinessLogic {
    func prepareSetUpUI(request: CuotasClean.Texts.Request)
    func getCuotas()
    func handleDidSelectRow(request: CuotasClean.CuotasDetails.Request)
}

protocol CuotasCleanDataStore {
    var amountEntered: Int! { get set }
    var selectedPaymentMethod: PaymentMethodModel! { get set }
    var bankSelected: BankSelectModel? { get set }
    var cuotasModelArray: [CuotasResult.PayerCost]? { get set }
}

class CuotasCleanInteractor: CuotasCleanBusinessLogic, CuotasCleanDataStore {
    var presenter: CuotasCleanPresentationLogic?
    var worker: CuotasCleanWorker? = CuotasCleanWorker()
    
    var amountEntered: Int!
    var selectedPaymentMethod: PaymentMethodModel!
    var bankSelected: BankSelectModel?
    var cuotasModelArray: [CuotasResult.PayerCost]?
    
    // MARK: Methods
    func prepareSetUpUI(request: CuotasClean.Texts.Request) {
        guard let selectedPaymentName = selectedPaymentMethod?.name else {
            return
        }
        let displayName = bankSelected?.name ?? selectedPaymentName
        let response = CuotasClean.Texts.Response(title: displayName)
        presenter?.presentSetUpUI(response: response)
    }
    
    func getCuotas() {
        let request = CuotasClean.Cuotas.Request(
                amountEntered: amountEntered,
                selectedPaymentMethodId: selectedPaymentMethod,
                bankSelectedId: bankSelected
            )
        presenter?.presentSpinner()
        
        worker?.getCuotas(
            request: request,
            successCompletion: { (cuotas) in
                self.presenter?.hideSpinner()
                if let cuotas = cuotas?.first {
                    self.cuotasModelArray = cuotas.payerCosts
                    let response = CuotasClean.Cuotas.Response.Success(cuotasModelArray: cuotas.payerCosts)
                    self.presenter?.presentCuotas(response: response)
                } else {
                    let response = CuotasClean.Cuotas.Response.Failure(
                        errorTitle: "Error",
                        errorMessage: "Error Parsing",
                        buttonTitle: "Cancel")

                    self.presenter?.presentErrorAlert(response: response)
                }
        }) { (error) in
            self.presenter?.hideSpinner()
            let response = CuotasClean.Cuotas.Response.Failure(
                errorTitle: "Error",
                errorMessage: "Service Error",
                buttonTitle: "Cancel"
            )
            self.presenter?.presentErrorAlert(response: response)
        }
    }
    
    func handleDidSelectRow(request: CuotasClean.CuotasDetails.Request) {
        if let amountEntered = amountEntered,
            let  selectedPaymentMethod = selectedPaymentMethod {
            let bankSelectedName = bankSelected?.name ?? selectedPaymentMethod.name
            let finalMessage = "Amount: $\(amountEntered)\n"
                + "Selected Payment Method: \(selectedPaymentMethod.name)\n"
                + "Bank Selected: \(bankSelectedName)\n"
                + cuotasModelArray![request.indexPath.row].recommendedMessage
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "cuotasFinishedNotification"),
                object: nil,
                userInfo: ["finalMessage": finalMessage]
            )
        } else {
            let response = CuotasClean.Cuotas.Response.Failure(
                errorTitle: "Error",
                errorMessage: "Error Parsing",
                buttonTitle: "Cancel"
            )
            self.presenter?.presentErrorAlert(response: response)
        }
    }
}
