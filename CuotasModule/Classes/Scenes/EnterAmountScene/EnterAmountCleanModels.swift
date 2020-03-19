//
//  EnterAmountCleanModels.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

enum EnterAmountClean {
  // MARK: Use cases
  
  enum EnterAmount {
    struct Request {
    }
    struct Response {
        struct Success {
            var successTitle: String
            var successMessage: String
            var buttonTitle: String
        }
        struct Error {
            var errorTitle: String
            var errorMessage: String
            var buttonTitle: String
        }
    }
    
    struct ViewModel {
        struct DisplayAmountEntered {
            var amountEntered: String
        }
        var displayAmountEntered: String
        
        struct Failure {
            var errorTitle: String
            var errorMessage: String
            var buttonTitle: String
        }
        struct TotalSuccess {
            var successTitle: String
            var successMessage: String
            var buttonTitle: String
        }
    }
  }
}
