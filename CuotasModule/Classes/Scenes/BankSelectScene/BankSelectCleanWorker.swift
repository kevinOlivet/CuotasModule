//
//  BankSelectCleanWorker.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons

class BankSelectCleanWorker {
    
    var reachability: ReachabilityCheckingProtocol = Reachability()
    var repo: APICuotasModuleProtocol = APICuotasModule()

    func getBankSelect(
        request: BankSelectClean.BankSelect.Request,
        successCompletion: @escaping ([BankSelectModel]?) -> Void,
        failureCompletion: @escaping (NTError) -> Void
    ) {
        guard reachability.isConnectedToNetwork() == true else {
            failureCompletion(NTError.noInternetConection)
            return
        }
        repo.getBankSelect(
            selectedPaymentMethodId: request.selectedPaymentMethod.id,
            success: { (receivedBankSelectModels, _) in
                successCompletion(receivedBankSelectModels)
            },
            failure: { (error, _) in
                failureCompletion(error)
            }
        )
    }
}
