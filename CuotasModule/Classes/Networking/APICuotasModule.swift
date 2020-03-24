//
//  APICuotasModule.swift
//  CuotasModule
//
//  Created by Jon Olivet on 8/28/18.
//  Copyright © 2018 Jon Olivet. All rights reserved.
//

import Commons

protocol APICuotasModuleProtocol {
    func getPaymentMethods(successCompletion: @escaping ([PaymentMethodModel]?) -> Void,
                           failureCompletion: @escaping (String) -> Void)

    func getBankSelect(selectedPaymentMethodId: String,
                       successCompletion: @escaping ([BankSelectModel]?) -> Void,
                       failureCompletion: @escaping (String) -> Void)

    func getCuotas(amountEntered: Int,
                   selectedPaymentMethodId: String,
                   bankSelectedId: String,
                   successCompletion: @escaping ([CuotasModel]?) -> Void,
                   failureCompletion: @escaping (String) -> Void)
}

class APICuotasModule: Networker, APICuotasModuleProtocol {

    // PaymentMethod
    func getPaymentMethods(successCompletion: @escaping ([PaymentMethodModel]?) -> Void,
                           failureCompletion: @escaping (String) -> Void) {

        let url = Configuration.Api.paymentMethods
//        let url = "https://api.mercadopago.com/v1/payment_methods?public_key=444a9ef5-8a6b-429f-abdf-587639155d88"

        var paymentMethodArray: [PaymentMethodModel] = []

        guard let urlStable = URL(string: url) else { return }
        let request = URLRequest(url: urlStable)

        let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else {
                failureCompletion(error!.localizedDescription)
                return }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                failureCompletion("statusCode mishap: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return }
            guard let data = data else {
                failureCompletion("Error with data".localized())
                return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] {
                    for dict in json {
                        guard let name = dict["name"] as? String else { return }
                        guard let paymentId = dict["id"] as? String else { return }
                        guard let secureThumbnail = dict["secure_thumbnail"] as? String else { return }
                        guard let paymentTypeId = dict["payment_type_id"] as? String else { return }
                        guard let minAllowedAmount = dict["min_allowed_amount"] as? Double else { return }
                        guard let maxAllowedAmount = dict["max_allowed_amount"] as? Double else { return }
                        let paymentMethod = PaymentMethodModel(name: name, paymentId: paymentId,
                                                               secureThumbnail: secureThumbnail,
                                                               paymentTypeId: paymentTypeId,
                                                               minAllowedAmount: minAllowedAmount,
                                                               maxAllowedAmount: maxAllowedAmount)
                        paymentMethodArray.append(paymentMethod)
                    }
                    DispatchQueue.main.async {
                        successCompletion(paymentMethodArray)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    failureCompletion(error.localizedDescription)
                }
            }
        }
        task.resume()
    }

    // BankSelect
    func getBankSelect(selectedPaymentMethodId: String,
                       successCompletion: @escaping ([BankSelectModel]?) -> Void,
                       failureCompletion: @escaping (String) -> Void) {

        let url = Configuration.Api.bankSelect + "&payment_method_id=\(selectedPaymentMethodId)"
//        let url = "https://api.mercadopago.com/v1/payment_methods/card_issuers?public_key=444a9ef5-8a6b-429f-abdf-587639155d88&payment_method_id=\(selectedPaymentMethodId)"

        var bankSelectModelArray: [BankSelectModel] = []

        guard let urlStable = URL(string: url) else { return }
        let request = URLRequest(url: urlStable)

        let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else {
                failureCompletion(error!.localizedDescription)
                return }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                failureCompletion("statusCode mishap: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return }
            guard let data = data else {
                failureCompletion("Error with data".localized())
                return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] {
                    for dict in json {
                        guard let name = dict["name"] as? String else { return }
                        guard let bankId = dict["id"] as? String else { return }
                        guard let secureThumbnail = dict["secure_thumbnail"] as? String else { return }
                        let bankSelectModel = BankSelectModel(name: name,
                                                              bankId: bankId,
                                                              secureThumbnail: secureThumbnail)
                        bankSelectModelArray.append(bankSelectModel)
                    }
                    DispatchQueue.main.async {
                        successCompletion(bankSelectModelArray)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    failureCompletion(error.localizedDescription)
                }
            }
        }
        task.resume()
    }

    // Cuotas Methods

    func getCuotas(amountEntered: Int,
                   selectedPaymentMethodId: String,
                   bankSelectedId: String,
                   successCompletion: @escaping ([CuotasModel]?) -> Void,
                   failureCompletion: @escaping (String) -> Void) {

        let url = Configuration.Api.cuotas + "&amount=\(amountEntered)&payment_method_id=\(selectedPaymentMethodId)&issuer.id=\(bankSelectedId)"
//        let url = "https://api.mercadopago.com/v1/payment_methods/installments?public_key=444a9ef5-8a6b-429f-abdf-587639155d88&amount=\(amountEntered)&payment_method_id=\(selectedPaymentMethodId)&issuer.id=\(bankSelectedId)"
        print("Here: ", url)

        var cuotaModelArray: [CuotasModel] = []

        guard let urlStable = URL(string: url) else { return }
        let request = URLRequest(url: urlStable)

        let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else {
                failureCompletion(error!.localizedDescription)
                return }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                failureCompletion("statusCode mishap: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return }
            guard let data = data else {
                failureCompletion("Error with data".localized())
                return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] {
                    for dict in json {
                        let cast = dict as! [String: AnyObject]
                        let payerCosts = cast["payer_costs"] as! [AnyObject]
                        for cost in payerCosts {
                            let costCast = cost as! [String: AnyObject]
                            guard let installments = costCast["installments"] as? Int else { return }
                            guard let recommendedMessage = costCast["recommended_message"] as? String else { return }
                            let cuota = CuotasModel(installments: installments,
                                                    recommendedMessage: recommendedMessage)
                            cuotaModelArray.append(cuota)
                        }
                    }
                    DispatchQueue.main.async {
                        successCompletion(cuotaModelArray)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    failureCompletion(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
