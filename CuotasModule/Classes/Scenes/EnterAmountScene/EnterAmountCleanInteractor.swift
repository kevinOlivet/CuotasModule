//
//  EnterAmountCleanInteractor.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons

protocol EnterAmountCleanBusinessLogic {
    func prepareSetUpUI(request: EnterAmountClean.Texts.Request)
    func handleNextButtonTapped(request: EnterAmountClean.EnterAmount.Request)
    func catchCuota(notification: Notification)
}

public protocol EnterAmountCleanDataStore {
    var amountEnteredDataStore: Int { get set }
}

class EnterAmountCleanInteractor: EnterAmountCleanBusinessLogic, EnterAmountCleanDataStore {
    var presenter: EnterAmountCleanPresentationLogic?
    var worker: EnterAmountCleanWorker?
    
    var amountEnteredDataStore: Int = 0
    let validator: TextValidationProtocol = NumericValidation()

    // MARK: Do something
    func prepareSetUpUI(request: EnterAmountClean.Texts.Request) {
        let response = EnterAmountClean.Texts.Response(
            title: "Amount",
            enterAmountLabel: "Enter amount in Chilean Pesos",
            nextButton: "Next"
        )
        presenter?.presentSetUpUI(response: response)
    }

    func handleNextButtonTapped(request: EnterAmountClean.EnterAmount.Request) {
        if !request.amountEntered.isEmpty {
            if validator.validateString(str: request.amountEntered) {
                if let amountEntered = Int(request.amountEntered) {
                    amountEnteredDataStore = amountEntered
                    presenter?.showPaymentMethod(amountEntered: amountEntered)
                }
            } else {
                let numberToUse = validator.getMatchingString(str: request.amountEntered)
                presenter?.setTextFieldWithRegexNumber(numberToUse: numberToUse!)
                
                let response = EnterAmountClean.EnterAmount.Response.Error(
                    errorTitle: "Invalid number",
                    errorMessage: validator.validationMessage,
                    buttonTitle: "Ok"
                )
                presenter?.presentInputAlert(response: response)
            }
        } else {
            let response = EnterAmountClean.EnterAmount.Response.Error(
                errorTitle: "Enter amount",
                errorMessage: "You need to enter an amount",
                buttonTitle: "Ok"
            )
            presenter?.presentInputAlert(response: response)
        }
    }
    
    func catchCuota(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let finalMessage = userInfo["finalMessage"] as? String else { return }
        let response = EnterAmountClean.EnterAmount.Response.Success(
            successTitle: "Finished",
            successMessage: finalMessage,
            buttonTitle: "Ok"
        )
        presenter?.presentCatchCuotaAlert(response: response)
    }
}
