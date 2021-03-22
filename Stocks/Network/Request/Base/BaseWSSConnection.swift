//
//  BaseWSSConnection.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 13.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

class BaseWSSConnection {

    // MARK: - Properties

    var queryItems: [URLQueryItem] {
        []
    }

    // MARK: - Public methods

    func subscribeToSymbolMessage(symbol: String) -> URLSessionWebSocketTask.Message? {
        return nil
    }

}

// MARK: - IWSSConnection

extension BaseWSSConnection: IWSSConnection {

    var urlRequest: URLRequest? {
        var components = URLComponents()
        components.scheme = "wss"
        components.host = "ws.finnhub.io"
        var query = queryItems
        // put api key here
        query.append(URLQueryItem(name: "token", value: ""))
        components.queryItems = query

        guard let url = components.url else {
            return nil
        }

        return URLRequest(url: url)
    }

}
