//
//  CuotasCleanWorker.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons

class CuotasCleanWorker {

    var reachability: ReachabilityCheckingProtocol = Reachability()
    var repo: APICuotasModuleProtocol = APICuotasModule()

    func getCuotas(request: CuotasClean.Cuotas.Request,
                   successCompletion: @escaping ([CuotasResult]?) -> Void,
                   failureCompletion: @escaping (NTError) -> Void) {

        let bankSelectedId = (request.bankSelectedId != nil) ? request.bankSelectedId!.id :  ""
        guard reachability.isConnectedToNetwork() == true else {
            failureCompletion(NTError.noInternetConection)
            return
        }
        repo.getCuotas(
            amountEntered: request.amountEntered,
            selectedPaymentMethodId: request.selectedPaymentMethodId.id,
            bankSelectedId: bankSelectedId,
            success: { cuotasResult, _ in
                successCompletion(cuotasResult)
            },
            failure: { error, _ in
                failureCompletion(error)
            }
        )
    }
}
