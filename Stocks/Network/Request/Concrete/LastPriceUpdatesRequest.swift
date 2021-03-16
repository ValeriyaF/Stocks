//
//  LastPriceUpdatesRequest.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 14.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

enum MessageType: String, Encodable {

    case subscribe

}

struct LastPriceUpdatesMessage: Encodable {

    let type: MessageType
    let symbol: String

}

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

final class LastPriceUpdatesConnection: BaseWSSConnection {

    private lazy var encoder = JSONEncoder()

    override func subscribeToSymbolMessage(symbol: String) -> URLSessionWebSocketTask.Message? {
        let msg = LastPriceUpdatesMessage(type: .subscribe, symbol: symbol)

        guard let jsonData = try? encoder.encode(msg),
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii) else {
                return nil
        }

        return URLSessionWebSocketTask.Message.string(jsonString)
    }

}
