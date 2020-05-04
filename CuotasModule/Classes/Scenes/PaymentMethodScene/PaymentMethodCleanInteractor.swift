//
//  PaymentMethodCleanInteractor.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

protocol PaymentMethodCleanBusinessLogic {
    func prepareSetUpUI(request: PaymentMethodClean.Texts.Request)
    func fetchPaymentMethods(request: PaymentMethodClean.PaymentMethods.Request)
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
    
    // MARK: Methods

    func prepareSetUpUI(request: PaymentMethodClean.Texts.Request) {
        let response = PaymentMethodClean.Texts.Response(title: amountEntered!)
        presenter?.presentSetupUI(response: response)
    }
    
    func fetchPaymentMethods(request: PaymentMethodClean.PaymentMethods.Request) {
        presenter?.presentLoadingView()
        
        worker?.getPaymentMethods(successCompletion: { (receivedPaymentMethods) in
            self.presenter?.hideLoadingView()
            if let receivedPaymentMethods = receivedPaymentMethods {
                for item in receivedPaymentMethods where item.paymentTypeId == "credit_card" {
                    self.paymentMethodArray.append(item)
                }
                let response = PaymentMethodClean.PaymentMethods.Response(paymentMethodArray: self.paymentMethodArray)
                self.presenter?.presentPaymentMethods(response: response)
            } else {
                let response = PaymentMethodClean.PaymentMethodsDetails.Response.Failure(errorType: .service)
                self.presenter?.presentErrorAlert(response: response)
            }
            
        }) { (_) in
            self.presenter?.hideLoadingView()
            let response = PaymentMethodClean.PaymentMethodsDetails.Response.Failure(errorType: .internet)
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
                let errorMessage = "\(selectedPaymentMethod.name)"
                    + "MINIMUM_MESSAGE".localized
                + "\(String(format: "%.2f", selectedPaymentMethod.minAllowedAmount))"
                    + "MAXIMUM_MESSAGE".localized
                    + "\(String(format: "%.2f", selectedPaymentMethod.maxAllowedAmount))"
                let response = PaymentMethodClean.PaymentMethodsDetails.Response.AmountFailure(
                    errorTitle: "CHOOSE_AGAIN",
                    errorMessage: errorMessage,
                    buttonTitle: "BIG_UNDERSTOOD"
                )
                presenter?.presentAmountErrorAlert(response: response)
            }
        }
    }
    
}
