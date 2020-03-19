//
//  PaymentMethodModel.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 8/28/18.
//  Copyright © 2018 Jon Olivet. All rights reserved.
//

import Foundation

struct PaymentMethodModel: Equatable {
    var name: String
    var paymentId: String
    var secureThumbnail: String
    var paymentTypeId: String
    var minAllowedAmount: Double
    var maxAllowedAmount: Double
}

