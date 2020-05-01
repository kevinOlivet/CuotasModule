//
//  PaymentMethodCleanModels.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicUIElements

enum PaymentMethodClean {
  // MARK: Use cases

    enum Texts {
        struct Request {}
        struct Response {
            let title: Int
        }
        struct ViewModel {
            let title: String
        }
    }
  
  enum PaymentMethods {
    struct Request {}
    struct Response {
        let paymentMethodArray: [PaymentMethodModel]
    }
    struct ViewModel {
        let displayPaymentMethodViewModelArray: [DisplayPaymentMethodViewModelSuccess]
        struct DisplayPaymentMethodViewModelSuccess: Equatable {
            let name: String
            let paymentId: String
            let secureThumbnail: String
            let paymentTypeId: String
            let minAllowedAmount: Double
            let maxAllowedAmount: Double
        }
    }
  }
    
    enum PaymentMethodsDetails {
        struct Request {
            let indexPath: Int
        }
        
        enum Response {
            struct Success {
                let amountEntered: Int
                let selectedPaymentMethod: PaymentMethodModel
            }
            struct Failure {
                let errorType: FullScreenErrorType
            }
            struct AmountFailure {
                let errorTitle: String
                let errorMessage: String
                let buttonTitle: String
            }
        }
        
        enum ViewModel {
            struct Success {
                let amountEntered: Int
                let selectedPaymentMethod: PaymentMethodModel
            }
            struct Failure {
                let errorType: FullScreenErrorType
            }
            struct AmountFailure {
                let errorTitle: String
                let errorMessage: String
                let buttonTitle: String
                let image: UIImage
            }
        }
        
    }
}



