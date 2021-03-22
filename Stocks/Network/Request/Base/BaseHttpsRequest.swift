//
//  BaseHttpsRequest.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 25.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

class BaseHttpsRequest {

    // MARK: - Properties

    var httpMethod: RequestMethod {
        .get
    }

    var path: String {
        ""
    }

    var queryItems: [URLQueryItem] {
        []
    }

}

// MARK: - IRequest

extension BaseHttpsRequest: IRequest {

    var urlRequest: URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "finnhub.io"
        components.path = "/api/v1\(path)"
        components.queryItems = queryItems

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        // put api key here
        request.allHTTPHeaderFields = ["X-Finnhub-Token": ""]
        return request
    }

}
