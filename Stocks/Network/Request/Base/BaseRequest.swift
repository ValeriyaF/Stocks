//
//  BaseRequest.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 25.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

class BaseRequest: IRequest {

    var httpMethod: RequestMethod {
        .get
    }

    var path: String {
        ""
    }

    var queryItems: [URLQueryItem] {
        []
    }

    var urlRequest: URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "finnhub.io/api/v1/"
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = ["X-Finnhub-Token": "sandbox_c0ovj3v48v6rduk5poa0"] // TODO: - move api key
        return request
    }

}
