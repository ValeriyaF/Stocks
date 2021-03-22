//
//  DowJonesIndexRequest.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 25.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

final class DowJonesIndexRequest: BaseHttpsRequest {

    // MARK: - Overrides

    override var path: String {
        return "/index/constituents"
    }

    override var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "symbol", value: "^DJI")]
    }

}
