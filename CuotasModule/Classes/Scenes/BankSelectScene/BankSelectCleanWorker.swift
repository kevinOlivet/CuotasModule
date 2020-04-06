//
//  BankSelectCleanWorker.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import Foundation

class BankSelectCleanWorker {
  
    var repo: APICuotasModuleProtocol = APICuotasModule()

    func getBankSelect(
        request: BankSelectClean.BankSelect.Request,
        successCompletion: @escaping ([BankSelectModel]?) -> Void,
        failureCompletion: @escaping (String) -> Void
    ) {

        repo.getBankSelect(
            selectedPaymentMethodId: request.selectedPaymentMethod.id,
            success: { (receivedBankSelectModels, _) in
                successCompletion(receivedBankSelectModels)
            },
            failure: { (error, _) in
                failureCompletion(error.localizedDescription)
            }
        )
    }
}
