//
//  LastPriceUpdatesResponse.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 16.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

struct LastPriceUpdatesResponse: Decodable {

    let data: [SymbolLastPrice]

}

struct SymbolLastPrice: Decodable {

    let price: Double
    let symbol: String

    enum CodingKeys: String, CodingKey {
        case price = "p"
        case symbol = "s"
    }

}
