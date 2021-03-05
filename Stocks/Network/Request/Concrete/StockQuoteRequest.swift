//
//  StockQuoteRequest.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 04.03.2021.
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

final class StockQuoteRequest: BaseRequest {

    let symbol: String

    init(symbol: String) {
        self.symbol = symbol
    }

    override var path: String {
        return "/quote"
    }

    override var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "symbol", value: symbol)]
    }

}
