//
//  PaymentMethodCleanWorker.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import Commons

class PaymentMethodCleanWorker {
    
    var repo: APICuotasModuleProtocol = APICuotasModule()

    func getPaymentMethods(successCompletion: @escaping ([PaymentMethodModel]?) -> Void,
                           failureCompletion: @escaping (String) -> Void) {
        
        repo.getPaymentMethods(successCompletion: { (receivedPaymentMethods) in
            successCompletion(receivedPaymentMethods)
        }) { (error) in
            failureCompletion(error)
        }
    }
}
