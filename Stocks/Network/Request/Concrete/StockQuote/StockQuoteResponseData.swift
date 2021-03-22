//
//  StockQuoteResponseData.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 16.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

struct StockQuoteResponseData: Decodable {

    let dayOpenPrice: Double?
    let currentPrice: Double?

    enum CodingKeys: String, CodingKey {
        case dayOpenPrice = "o"
        case currentPrice = "c"
    }

}
