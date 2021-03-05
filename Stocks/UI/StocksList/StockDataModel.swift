//
//  StockDataModel.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 02.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

struct StockDataModel {

    var isFavourite: Bool = false
    var logoImageURL: String?
    var displaySymbol: String
    var description: String?
    var currentPrice: String?
    var dayDelta: String?
    var currency: CurrencyType?

    var isCompleted: Bool {
        description != nil && currentPrice != nil
    }

}

extension StockDataModel {

    init(displaySymbol: String) {
        self.displaySymbol = displaySymbol
    }

}
