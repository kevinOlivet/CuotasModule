//
//  APICuotasModule.swift
//  CuotasModule
//
//  Created by Jon Olivet on 8/28/18.
//  Copyright © 2018 Jon Olivet. All rights reserved.
//

import Alamofire
import BasicCommons

protocol APICuotasModuleProtocol {

    func getPaymentMethods(success: @escaping (_ result: [PaymentMethodModel], Int) -> Void,
                           failure: @escaping (_ error: NTError, Int) -> Void)

    func getBankSelect(selectedPaymentMethodId: String,
                       success: @escaping (_ result: [BankSelectModel], Int) -> Void,
                       failure: @escaping (_ error: NTError, Int) -> Void)

    func getCuotas(amountEntered: Int,
                   selectedPaymentMethodId: String,
                   bankSelectedId: String,
                   success: @escaping (_ result: [CuotasResult], Int) -> Void,
                   failure: @escaping (_ error: NTError, Int) -> Void)

    func downloadImage(urlString: String,
                       completion: @escaping (Data) -> Void)
}

class APICuotasModule: AuthenticatedAPI, APICuotasModuleProtocol {

    // Dependency Injection for testing
    public let session: URLSession
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    // PaymentMethod
    func getPaymentMethods(success: @escaping (_ result: [PaymentMethodModel], Int) -> Void,
                          failure: @escaping (_ error: NTError, Int) -> Void) {

        let url = Configuration.Api.paymentMethods

        self.requestGeneric(
            type: [PaymentMethodModel].self,
            url: url,
            method: HTTPMethod.get,
            parameters: nil,
            encoding: JSONEncoding.default,
            validStatusCodes: [Int](200..<300),
            onSuccess: { paymentMethodModelResult, _, statusCode in
                success(paymentMethodModelResult!, statusCode!)
            }, onFailure: { error, statusCode in
                failure(error, statusCode)
            }
        )
    }

    // BankSelect
    func getBankSelect(selectedPaymentMethodId: String,
                       success: @escaping (_ result: [BankSelectModel], Int) -> Void,
                       failure: @escaping (_ error: NTError, Int) -> Void) {

        let url = Configuration.Api.bankSelect + "&payment_method_id=\(selectedPaymentMethodId)"

        self.requestGeneric(
            type: [BankSelectModel].self,
            url: url,
            method: HTTPMethod.get,
            parameters: nil,
            encoding: JSONEncoding.default,
            validStatusCodes: [Int](200..<300),
            onSuccess: { bankSelectModelResult, _, statusCode in
                success(bankSelectModelResult!, statusCode!)
            }, onFailure: { error, statusCode in
                failure(error, statusCode)
            }
        )
    }

    // Cuotas Methods

    func getCuotas(amountEntered: Int,
                   selectedPaymentMethodId: String,
                   bankSelectedId: String,
                   success: @escaping (_ result: [CuotasResult], Int) -> Void,
                   failure: @escaping (_ error: NTError, Int) -> Void) {

        let url = Configuration.Api.cuotas + "&amount=\(amountEntered)&payment_method_id=\(selectedPaymentMethodId)&issuer.id=\(bankSelectedId)"

        self.requestGeneric(
            type: [CuotasResult].self,
            url: url,
            method: HTTPMethod.get,
            parameters: nil,
            encoding: JSONEncoding.default,
            validStatusCodes: [Int](200..<300),
            onSuccess: { cuotasResult, _, statusCode in
                success(cuotasResult!, statusCode!)
            }, onFailure: { error, statusCode in
                failure(error, statusCode)
            }
        )
    }

    public func downloadImage(urlString: String,
                              completion: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(data)
            }
        }
        task.resume()
    }
}
