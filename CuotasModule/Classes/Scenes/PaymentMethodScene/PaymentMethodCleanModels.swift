//
//  PaymentMethodCleanModels.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

enum PaymentMethodClean {
  // MARK: Use cases
  
  enum PaymentMethods {
    struct Request {
        var amountEntered: Int
    }
    struct Response {
        // Refers to an old method but so does Main to Models in Commons
        var paymentMethodArray: [PaymentMethodModel]
    }
    struct ViewModel {
        struct DisplayPaymentMethodViewModelSuccess: Equatable {
            var name: String
            var paymentId: String
            var secureThumbnail: String
            var paymentTypeId: String
            var minAllowedAmount: Double
            var maxAllowedAmount: Double
        }
        var displayPaymentMethodViewModelArray: [DisplayPaymentMethodViewModelSuccess]
    }
  }
    
    enum PaymentMethodsDetails {
        struct Request {
            var indexPath: Int
        }
        
        enum Response {
            struct Success {
                var amountEntered: Int
                var selectedPaymentMethod: PaymentMethodModel
            }
            struct Failure {
                var errorTitle: String
                var errorMessage: String
                var buttonTitle: String
            }
        }
        
        enum ViewModel {
            struct Success {
                var amountEntered: Int
                var selectedPaymentMethod: PaymentMethodModel
            }
            struct Failure {
                var errorTitle: String
                var errorMessage: String
                var buttonTitle: String
            }
        }
        
    }
}



