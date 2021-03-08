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

    func scrolledToTableBottom()

    func itemsCount() -> Int

    func stockDataModel(index: Int) -> StockDataModel

    func favouriteStateChanged(stockSymbol: String)

    func stocksListTypeChanged(isFavouriteMode: Bool)

    var isLoading: Bool { get }

    var loadMoreEnable: Bool { get }

}

final class StocksListPresenter: IStocksListPresenter {

    // MARK: - Dependencies

    private let stocksInfoService: IStocksInfoService
    weak var view: IStocksListView?

    // MARK: - Properties

    var isLoading: Bool = false
    private var _items = [StockDataModel]()
    private var filteredItems: [StockDataModel] {
        if isFavouriteMode {
            return _items.filter { $0.isFavourite }
        }

        return _items
    }
    private var isFavouriteMode = false

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
        loadStocks(limit: 10)
    }

    func scrolledToTableBottom() {
        isLoading = true
        view?.showLoadingMoreIndicator()

        stocksInfoService.loadMore(limit: 10) { [weak self] result in
            switch result {
            case .failure(let error):
                // TODO: - add
                fatalError("")
                break
            case .success(let dm):
                self?._items = dm
                DispatchQueue.main.async {
                    self?.view?.hideLoadingMoreIndicator()
                    self?.view?.updateStocks()
                    self?.isLoading = false
                }
            }
        }
    }

    func itemsCount() -> Int {
        filteredItems.count
    }

    func stockDataModel(index: Int) -> StockDataModel {
        return filteredItems[index]
    }

    func favouriteStateChanged(stockSymbol: String) {
        _items = stocksInfoService.updateFavoriteStatus(stockSymbol: stockSymbol)

        if isFavouriteMode {
            DispatchQueue.main.async {
                self.view?.updateStocks()
            }
        }
    }

    var loadMoreEnable: Bool {
        !stocksInfoService.stocksInfoFilled
    }

    func stocksListTypeChanged(isFavouriteMode: Bool) {
        self.isFavouriteMode = isFavouriteMode

        DispatchQueue.main.async {
            self.view?.updateStocks()
        }
    }

}

// MARK: - Private

extension StocksListPresenter {

    private func loadStocks(limit: Int) {
        isLoading = true

        stocksInfoService.refreshStocks(limit: limit) { [weak self] result in
            switch result {
            case .failure(let error):
                assertionFailure()
                // TODO: - add
                fatalError("")
            case .success(let dm):
                self?._items = dm
                DispatchQueue.main.async {
                    self?.view?.updateStocks()
                    self?.isLoading = false
                }
            }
        }
    }

}
