//
//  BankSelectModel.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 8/28/18.
//  Copyright © 2018 Jon Olivet. All rights reserved.
//

import Foundation

struct BankSelectModel: Codable {
    let name: String
    let id: String
    let secureThumbnail: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case secureThumbnail = "secure_thumbnail"
    }
}
