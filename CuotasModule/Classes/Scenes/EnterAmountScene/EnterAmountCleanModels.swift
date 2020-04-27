//
//  EnterAmountCleanModels.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import Foundation

enum EnterAmountClean {

    enum Texts {
        struct Request {}
        struct Response {
            let title: String
            let enterAmountLabel: String
            let nextButton: String
        }
        struct ViewModel {
            let title: String
            let enterAmountLabel: String
            let nextButton: String
        }
    }

    enum EnterAmount {
        struct Request {
            let amountEntered: String
        }
        struct Response {}
        struct ViewModel {}
    }

    enum CatchNotification {
        struct Request {
            let notification: Notification
        }
        struct Response {
            let successTitle: String
            let successMessage: String
            let buttonTitle: String
        }
        struct ViewModel {
            let successTitle: String
            let successMessage: String
            let buttonTitle: String
        }
    }

    enum Errors {
        struct Request {}
        struct Response {
            let errorTitle: String
            let errorMessage: String
            let buttonTitle: String
        }
        struct ViewModel {
            let errorTitle: String
            let errorMessage: String
            let buttonTitle: String
            let image: UIImage
        }
    }

    enum Regex {
        struct Request {}
        struct Response {
            let numberToUse: String
        }
        struct ViewModel {
            let numberToUse: String
        }
    }
}
