//
//  EnterAmountCleanInteractor.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import Commons

protocol EnterAmountCleanBusinessLogic {
    func handleNextButtonTapped(amountEntered: String)
    func catchCuota(notification: Notification)
}

public protocol EnterAmountCleanDataStore {
  var amountEnteredDataStore: Int { get set }
}

class EnterAmountCleanInteractor: EnterAmountCleanBusinessLogic, EnterAmountCleanDataStore {
  var presenter: EnterAmountCleanPresentationLogic?
  var worker: EnterAmountCleanWorker?
    
  var amountEnteredDataStore: Int = 0
  
  // MARK: Do something
  
    func handleNextButtonTapped(amountEntered: String) {
        if !amountEntered.isEmpty {
            let validator = NumericValidation.sharedInstance
            if validator.validateString(str: amountEntered) {
                if let amountEntered = Int(amountEntered) {
                    amountEnteredDataStore = amountEntered
                    presenter?.showPaymentMethod(amountEntered: amountEntered)
                }
            } else {
                let numberToUse = validator.getMatchingString(str: amountEntered)
                presenter?.setTextFieldWithRegexNumber(numberToUse: numberToUse!)
                
                let response = EnterAmountClean.EnterAmount.Response.Error(errorTitle: "Invalid number".localized(),
                                                                           errorMessage: validator.validationMessage,
                                                                           buttonTitle: "Ok".localized())
                presenter?.presentNumberToUseAlert(response: response)
            }
        } else {
            let response = EnterAmountClean.EnterAmount.Response.Error(errorTitle: "Enter amount".localized(),
                                                                       errorMessage: "You need to enter an amount".localized(),
                                                                       buttonTitle: "Ok".localized())
            presenter?.presentEnterAmountAlert(response: response)
        }
    }
    
    func catchCuota(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let finalMessage = userInfo["finalMessage"] as? String else { return }
        let response = EnterAmountClean.EnterAmount.Response.Success(successTitle: "Finished".localized(),
                                                                     successMessage: finalMessage,
                                                                     buttonTitle: "Ok".localized())
        presenter?.presentCatchCuotaAlert(response: response)
    }
}
