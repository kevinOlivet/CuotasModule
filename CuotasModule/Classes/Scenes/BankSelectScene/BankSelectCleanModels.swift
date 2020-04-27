//
//  BankSelectCleanModels.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicUIElements

enum BankSelectClean {
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
    
    enum BankSelect {
        struct Request {}
        enum Response {
            struct Success {
                let bankSelectArray: [BankSelectModel]
                let selectedPaymentMethod: PaymentMethodModel
            }
            struct Failure {
                let errorType: FullScreenErrorType
            }
        }
        enum ViewModel {
            struct DisplayBankSelect {
                let name: String
                let bankId: String
                let secureThumbnail: String
            }
            struct Success {
                let bankSelectArray: [DisplayBankSelect]
                let selectedPaymentMethod: PaymentMethodModel
            }
            struct Failure {
                let errorType: FullScreenErrorType
            }
        }
    }
    
    enum BankSelectDetails {
        struct Request {
            let indexPath: IndexPath
        }
        
        enum Response {
            struct Success {
                let amountEntered: Int
                let selectedPaymentMethod: PaymentMethodModel
                let bankSelected: BankSelectModel?
            }
            struct Failure {
                let errorType: FullScreenErrorType
            }
        }
        
        enum ViewModel {
            struct Success {
                let amountEntered: Int
                let selectedPaymentMethod: PaymentMethodModel
                let bankSelected: BankSelectModel?
            }
            struct Failure {
                let errorType: FullScreenErrorType
            }
        }
    }
}
