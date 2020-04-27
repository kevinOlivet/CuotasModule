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
    func catchCuota(request: EnterAmountClean.CatchNotification.Request)
}

public protocol EnterAmountCleanDataStore {
    var amountEnteredDataStore: Int { get set }
}

class EnterAmountCleanInteractor: EnterAmountCleanBusinessLogic, EnterAmountCleanDataStore {
    var presenter: EnterAmountCleanPresentationLogic?
    var worker: EnterAmountCleanWorker?
    
    var amountEnteredDataStore: Int = 0
    let validator: TextValidationProtocol = NumericValidation()

    // MARK: Methods
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
            if validator.validateString(str: request.amountEntered),
                let amountEntered = Int(request.amountEntered),
                amountEntered > 0 {
                amountEnteredDataStore = amountEntered
                presenter?.presentPaymentMethod()
            } else {
                let numberToUse = validator.getMatchingString(str: request.amountEntered)
                let numberResponse = EnterAmountClean.Regex.Response(numberToUse: numberToUse!)
                presenter?.presentTextFieldWithRegexNumber(response: numberResponse)
                
                let response = EnterAmountClean.Errors.Response(
                    errorTitle: "Invalid number",
                    errorMessage: validator.validationMessage,
                    buttonTitle: "UNDERSTOOD"
                )
                presenter?.presentInputAlert(response: response)
            }
        } else {
            let response = EnterAmountClean.Errors.Response(
                errorTitle: "Enter amount",
                errorMessage: "You need to enter an amount",
                buttonTitle: "UNDERSTOOD"
            )
            presenter?.presentInputAlert(response: response)
        }
    }
    
    func catchCuota(request: EnterAmountClean.CatchNotification.Request) {
        guard let userInfo = request.notification.userInfo,
            let finalMessage = userInfo["finalMessage"] as? String else { return }
        let response = EnterAmountClean.CatchNotification.Response(
            successTitle: "Finished",
            successMessage: finalMessage,
            buttonTitle: "Ok"
        )
        presenter?.presentCatchCuotaAlert(response: response)
    }
}
