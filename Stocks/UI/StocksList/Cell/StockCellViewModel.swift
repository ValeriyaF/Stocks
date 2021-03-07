//
//  StockCellViewModel.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 02.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import UIKit

final class StockCellViewModel {

    // MARK: - Properties

    var logoImageString: String?
    var isFavourite: Bool
    var isEmphasized: Bool
    var displaySymbol: String
    var description: String
    var currentPrice: String
    var dayDelta: String?
    var isNegativeDayDelta: Bool = false
    var currency: CurrencyType?

    var favouriteStateChangedCompletion: (String) -> Void

    // MARK: - Initialisation

    init(with dm: StockDataModel, isEmphasized: Bool, favouriteStateChangedCompletion: @escaping (String) -> Void) {
        logoImageString = dm.logoImageString
        isFavourite = dm.isFavourite
        self.isEmphasized = isEmphasized
        displaySymbol = dm.displaySymbol
        description = dm.description ?? ""

        let currencySymbol = dm.currency?.symbol ?? ""
        var currentPrice = currencySymbol
        currentPrice += String(format: "%.2f", dm.currentPrice ?? 0)
        self.currentPrice = currentPrice

        isNegativeDayDelta = false
        if let dayDelta = dm.dayDelta,
            let dayDeltaPersent = dm.dayDeltaPersent {
            let sign = dayDelta >= 0 ? "+" : "-"
            isNegativeDayDelta = dayDelta < 0
            self.dayDelta = String(format: "\(sign)\(currencySymbol)%.2f (%.2f%%)",
                abs(dayDelta),
                abs(dayDeltaPersent))
        }

        currency = dm.currency
        self.favouriteStateChangedCompletion = favouriteStateChangedCompletion
    }
    
}

extension StockCellViewModel {

    func favouriteStateChanged() {
        isFavourite = !isFavourite
        favouriteStateChangedCompletion(displaySymbol)
    }

}
