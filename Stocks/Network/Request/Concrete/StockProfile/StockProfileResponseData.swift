//
//  StockProfileResponseData.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 16.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

enum CurrencyType: String, Decodable {

    case USD

    var symbol: String {
        switch self {
        case .USD:
            return "$"
        }
    }

}

struct StockProfileResponseData: Decodable {

    let currency: CurrencyType?
    let logoURL: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case currency
        case logoURL = "logo"
        case name
    }

}
