//
//  CuotasCleanModels.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicUIElements

enum CuotasClean {
  // MARK: Use cases

    enum Texts {
        struct Request {}
        struct Response {
            let title: String
        }
        struct ViewModel {
            let title: String
        }
    }

  enum Cuotas {
    struct Request {
        let amountEntered: Int
        let selectedPaymentMethodId: PaymentMethodModel
        let bankSelectedId: BankSelectModel?
    }
    enum Response {
        struct Success {
            let cuotasModelArray: [CuotasResult.PayerCost]
        }
        struct Failure {
            let errorType: FullScreenErrorType
        }
    }
    enum ViewModel {
        
        struct DisplayCuota {
            let installments: String
            let recommendedMessage: String
        }
        
        struct Success {
            let cuotasModelArray: [DisplayCuota]
        }
        
        struct Failure {
            let errorType: FullScreenErrorType
        }
    }
  }
    
    enum CuotasDetails {
        struct Request {
            let indexPath: IndexPath
        }
    }
}
