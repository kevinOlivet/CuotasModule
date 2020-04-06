//
//  CuotasModel.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 8/28/18.
//  Copyright © 2018 Jon Olivet. All rights reserved.
//

import Foundation

struct CuotasResult: Codable {
    let payerCosts: [PayerCost]

    enum CodingKeys: String, CodingKey {
        case payerCosts = "payer_costs"
    }

    struct PayerCost: Codable {
        let installments: Int
        let recommendedMessage: String

        enum CodingKeys: String, CodingKey {
            case installments
            case recommendedMessage = "recommended_message"
        }
    }
}
