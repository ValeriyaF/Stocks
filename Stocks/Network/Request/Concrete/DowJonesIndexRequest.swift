//
//  DowJonesIndexRequest.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 25.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

struct DowJonesIndexResponceData: Decodable {

    let constituents: [String]

    enum CodingKeys: String, CodingKey {
        case constituents
    }
    
}

final class DowJonesIndexRequest: BaseRequest {

    override var path: String {
        return "/index/constituents"
    }

    override var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "symbol", value: "^DJI")]
    }

}
