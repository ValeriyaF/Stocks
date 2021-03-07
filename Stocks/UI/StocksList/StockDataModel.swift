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
    var dayDelta: Double?
    var dayDeltaPersent: Double?
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
