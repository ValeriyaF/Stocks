//
//  StockCellViewModel.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 02.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import UIKit

struct StockCellViewModel {

    var logoImage: UIImage? // https://medium.com/flawless-app-stories/reusable-image-cache-in-swift-9b90eb338e8d
    var isFavourite: Bool
    var isEmphasized: Bool
    var displaySymbol: String
    var description: String
    var currentPrice: String
    var dayDelta: String?

}

extension StockCellViewModel {

    init(with dm: StockDataModel, isEmphasized: Bool) {
//        logoImage = dm.logoImage
        isFavourite = dm.isFavourite
        displaySymbol = dm.displaySymbol
        description = dm.description ?? ""
        currentPrice = dm.currentPrice ?? ""
        dayDelta = dm.dayDelta
        self.isEmphasized = isEmphasized
    }

}
