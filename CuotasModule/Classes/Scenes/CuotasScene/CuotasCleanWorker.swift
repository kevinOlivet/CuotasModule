//
//  CuotasCleanWorker.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

class CuotasCleanWorker {
    
    var repo: APICuotasModuleProtocol = APICuotasModule()

    func getCuotas(request: CuotasClean.Cuotas.Request,
                   successCompletion: @escaping ([CuotasResult]?) -> Void,
                   failureCompletion: @escaping (String) -> Void) {

        let bankSelectedId = (request.bankSelectedId != nil) ? request.bankSelectedId!.id :  ""

        repo.getCuotas(
            amountEntered: request.amountEntered,
            selectedPaymentMethodId: request.selectedPaymentMethodId.id,
            bankSelectedId: bankSelectedId,
            success: { cuotasResult, _ in
                successCompletion(cuotasResult)
            },
            failure: { error, _ in
                failureCompletion(error.localizedDescription)
            }
        )
    }
}
