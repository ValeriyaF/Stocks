//
//  LastPriceUpdatesMessage.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 16.03.2021.
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
