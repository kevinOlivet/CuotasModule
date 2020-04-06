//
//  PaymentMethodCleanWorker.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons

class PaymentMethodCleanWorker {
    var reachability: ReachabilityCheckingProtocol = Reachability()
    var repo: APICuotasModuleProtocol = APICuotasModule()

    func getPaymentMethods(
        successCompletion: @escaping ([PaymentMethodModel]?) -> Void,
        failureCompletion: @escaping (NTError) -> Void
    ) {
        guard reachability.isConnectedToNetwork() == true else {
            failureCompletion(NTError.noInternetConection)
            return
        }
        repo.getPaymentMethods(
            success: { receivedPaymentMethods, _ in
                successCompletion(receivedPaymentMethods)
            }) { error, _ in
                failureCompletion(error)
            }
    }
}
