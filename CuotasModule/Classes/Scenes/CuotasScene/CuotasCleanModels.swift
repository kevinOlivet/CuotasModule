//
//  CuotasCleanModels.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

enum CuotasClean {
  // MARK: Use cases
  
  enum Cuotas {
    struct Request {
        var amountEntered: Int
        var selectedPaymentMethodId: PaymentMethodModel
        var bankSelectedId: BankSelectModel?
    }
    enum Response {
        struct Success {
            var cuotasModelArray: [CuotasResult.PayerCost]
        }
        struct Failure {
            var errorTitle: String
            var errorMessage: String
            var buttonTitle: String
        }
    }
    enum ViewModel {
        
        struct DisplayCuota {
            var installments: String
            var recommendedMessage: String
        }
        
        struct Success {
            var cuotasModelArray: [DisplayCuota]
        }
        
        struct Failure {
            var errorTitle: String
            var errorMessage: String
            var buttonTitle: String
        }
    }
  }
    
    enum CuotasDetails {
        struct Request {
            var indexPath: IndexPath
        }
    }
}
