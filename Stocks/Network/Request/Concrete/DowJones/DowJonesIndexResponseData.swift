//
//  DowJonesIndexResponseData.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 16.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

struct DowJonesIndexResponseData: Decodable {

    let constituents: [String]

    enum CodingKeys: String, CodingKey {
        case constituents
    }

}
