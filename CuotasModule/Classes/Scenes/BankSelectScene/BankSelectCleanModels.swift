//
//  BankSelectCleanModels.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

enum BankSelectClean {
    // MARK: Use cases
    
    enum BankSelect {
        struct Request {
            var selectedPaymentMethod: PaymentMethodModel
        }
        enum Response {
            struct Success {
                var bankSelectArray: [BankSelectModel]
                var selectedPaymentMethod: PaymentMethodModel
            }
            struct Failure {
                var errorTitle: String
                var errorMessage: String
                var buttonTitle: String
            }
        }
        enum ViewModel {
            struct DisplayBankSelect {
                var name: String
                var bankId: String
                var secureThumbnail: String
            }
            struct Success {
                var bankSelectArray: [DisplayBankSelect]
                var selectedPaymentMethod: PaymentMethodModel
            }
            struct Failure {
                var errorTitle: String
                var errorMessage: String
                var buttonTitle: String
            }
        }
    }
    
    enum BankSelectDetails {
        struct Request {
            var indexPath: IndexPath
        }
        
        enum Response {
            struct Success {
                var amountEntered: Int
                var selectedPaymentMethod: PaymentMethodModel
                var bankSelected: BankSelectModel?
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
                var bankSelected: BankSelectModel?
            }
            struct Failure {
                var errorTitle: String
                var errorMessage: String
                var buttonTitle: String
            }
        }
    }
}
