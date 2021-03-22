//
//  StockDataModel.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 02.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

struct StockDataModel {

    var isFavourite: Bool
    var logoImageString: String?
    var displaySymbol: String
    var description: String?
    var currentPrice: Double?
    var dayOpenPrice: Double?
    var dayDelta: Double? {
        guard let currentPrice = currentPrice,
            let dayOpenPrice = dayOpenPrice else {
            return nil
        }

        return currentPrice - dayOpenPrice
    }

    var dayDeltaPersent: Double? {
        guard let currentPrice = currentPrice,
            let dayOpenPrice = dayOpenPrice else {
            return nil
        }

        return 100 * (currentPrice - dayOpenPrice) / dayOpenPrice
    }

    var currency: CurrencyType?

    var isCompleted: Bool {
        description != nil && currentPrice != nil
    }

}

extension StockDataModel {

    init(displaySymbol: String, isFavourite: Bool) {
        self.displaySymbol = displaySymbol
        self.isFavourite = isFavourite
    }

}
