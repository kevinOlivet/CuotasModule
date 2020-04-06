//
//  PaymentMethodModel.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 8/28/18.
//  Copyright © 2018 Jon Olivet. All rights reserved.
//

import Foundation

struct PaymentMethodModel: Codable {
    let name: String
    let id: String
    let secureThumbnail: String
    let paymentTypeId: String
    let minAllowedAmount: Double
    let maxAllowedAmount: Double

    enum CodingKeys: String, CodingKey {
        case id, name
        case paymentTypeId = "payment_type_id"
        case secureThumbnail = "secure_thumbnail"
        case minAllowedAmount = "min_allowed_amount"
        case maxAllowedAmount = "max_allowed_amount"
    }
}

