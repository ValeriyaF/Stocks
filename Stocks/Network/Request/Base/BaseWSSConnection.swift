//
//  BaseWSSConnection.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 13.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

class BaseWSSConnection: IWSSConnection {

    var queryItems: [URLQueryItem] {
        []
    }

    var urlRequest: URLRequest? {
        var components = URLComponents()
        components.scheme = "wss"
        components.host = "ws.finnhub.io"
        var query = queryItems
        query.append(URLQueryItem(name: "token", value: "c0ovj3v48v6rduk5po9g"))
        components.queryItems = query

        guard let url = components.url else {
            return nil
        }

        return URLRequest(url: url)
    }

    func subscribeToSymbolMessage(symbol: String) -> URLSessionWebSocketTask.Message? {
        return nil
    }

}
