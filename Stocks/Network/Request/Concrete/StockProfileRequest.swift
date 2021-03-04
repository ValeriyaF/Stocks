//
//  StockProfileRequest.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 03.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

enum CurrencyType: String, Decodable {

    case USD

}

struct StockProfileResponseData: Decodable {

    let currency: CurrencyType
    let logoURL: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case currency
        case logoURL = "logo"
        case name
    }

}

final class StockProfileRequest: BaseRequest {

    let symbol: String

    init(symbol: String) {
        self.symbol = symbol
    }

    override var path: String {
        return "/stock/profile2"
    }

    override var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "symbol", value: symbol)]
    }

}
