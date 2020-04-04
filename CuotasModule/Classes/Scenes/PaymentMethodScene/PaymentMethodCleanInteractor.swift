//
//  PaymentMethodCleanInteractor.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol PaymentMethodCleanBusinessLogic {
    func getPaymentMethods(request: PaymentMethodClean.PaymentMethods.Request)
    func handleDidSelectRow(request: PaymentMethodClean.PaymentMethodsDetails.Request)
}

protocol PaymentMethodCleanDataStore {
    var amountEntered: Int? { get set }
    var selectedPaymentMethod: PaymentMethodModel! { get set }
}

class PaymentMethodCleanInteractor: PaymentMethodCleanBusinessLogic, PaymentMethodCleanDataStore {
    var presenter: PaymentMethodCleanPresentationLogic?
    var worker: PaymentMethodCleanWorker? = PaymentMethodCleanWorker()
    
    var amountEntered: Int?
    var selectedPaymentMethod: PaymentMethodModel!
    var paymentMethodArray = [PaymentMethodModel]()
    
    // MARK: Do something
    
    func getPaymentMethods(request: PaymentMethodClean.PaymentMethods.Request) {
        presenter?.presentSpinner()
        
        worker?.getPaymentMethods(successCompletion: { (receivedPaymentMethods) in
            self.presenter?.hideSpinner()
            if let receivedPaymentMethods = receivedPaymentMethods {
                for item in receivedPaymentMethods where item.paymentTypeId == "credit_card" {
                    self.paymentMethodArray.append(item)
                }
                let response = PaymentMethodClean.PaymentMethods.Response(paymentMethodArray: receivedPaymentMethods)
                self.paymentMethodArray = response.paymentMethodArray
                self.presenter?.presentPaymentMethods(response: response)
            } else {
                let response = PaymentMethodClean.PaymentMethodsDetails.Response.Failure(
                    errorTitle: "Error".localized(),
                    errorMessage: "Error Parsing".localized(),
                    buttonTitle: "Cancel".localized()
                )
                self.presenter?.presentErrorAlert(response: response)
            }
            
        }) { (error) in
            self.presenter?.hideSpinner()
            let response = PaymentMethodClean.PaymentMethodsDetails.Response.Failure(
                errorTitle: "Error".localized(),
                errorMessage: error,
                buttonTitle: "Cancel".localized()
            )
            self.presenter?.presentErrorAlert(response: response)
        }
    }
    
    func handleDidSelectRow(request: PaymentMethodClean.PaymentMethodsDetails.Request) {
        selectedPaymentMethod = paymentMethodArray[request.indexPath]
        if let amountEntered = amountEntered {
            if Double(amountEntered) > selectedPaymentMethod.minAllowedAmount && Double(amountEntered) < selectedPaymentMethod.maxAllowedAmount {
                
                let response = PaymentMethodClean.PaymentMethodsDetails.Response.Success(
                    amountEntered: amountEntered,
                    selectedPaymentMethod: selectedPaymentMethod
                )
                presenter?.showBankSelect(response: response)
            } else {
                
                let errorMessage = "\(selectedPaymentMethod.name) has a minimum amount of \(String(format: "%.2f", selectedPaymentMethod.minAllowedAmount)) and a maximum ammount of \(String(format: "%.2f", selectedPaymentMethod.maxAllowedAmount))".localized()
                
                let response = PaymentMethodClean.PaymentMethodsDetails.Response.Failure(
                    errorTitle: "Choose another".localized(),
                    errorMessage: errorMessage,
                    buttonTitle: "Ok".localized()
                )
                presenter?.presentWrongAmountAlert(response: response)
            }
        }
    }
    
}
