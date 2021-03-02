//
//  StocksListPresenter.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 28.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

protocol IStocksListPresenter {

    func viewDidLoad()

    func itemsCount() -> Int

}

final class StocksListPresenter: IStocksListPresenter {

    // MARK: - Dependencies

    private let stocksInfoService: IStocksInfoService
    weak var view: IStocksListView?

    // MARK: - Properties

    private var items = [StockDataModel]()


    // MARK: - Initialisation

    init(view: IStocksListView,
         stocksInfoService: IStocksInfoService) {
        self.stocksInfoService = stocksInfoService
        self.view = view
    }

}

// MARK: - IStocksListPresenter

extension StocksListPresenter {

    func viewDidLoad() {
        stocksInfoService.loadStocks(limit: 5) { res in

        }
    }

    func itemsCount() -> Int {
        items.count
    }

}
