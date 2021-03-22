//
//  StockQuoteRequest.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 04.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

final class StockQuoteRequest: BaseHttpsRequest {

    let symbol: String

    // MARK: - Initialisation

    init(symbol: String) {
        self.symbol = symbol
    }

    // MARK: - Overrides

    override var path: String {
        return "/quote"
    }

    override var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "symbol", value: symbol)]
    }

}
