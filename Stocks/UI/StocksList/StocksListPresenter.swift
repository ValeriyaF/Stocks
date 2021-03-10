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

    func refreshStocks()

    func scrolledToTableBottom()

    func itemsCount() -> Int

    func stockDataModel(index: Int) -> StockDataModel

    func favouriteStateChanged(stockSymbol: String)

    func stocksListTypeChanged(isFavouriteMode: Bool)

    func searchResultsUpdated(searchPhrase: String)

    func searchFinished()

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
        var filtered = _items
        if let searchPhrase = searchPhrase, !searchPhrase.isEmpty {
            filtered = filtered.filter { $0.description?.lowercased().contains(searchPhrase) ?? false
                || $0.displaySymbol.lowercased().contains(searchPhrase) }
        }

        if isFavouriteMode {
            filtered = filtered.filter { $0.isFavourite }
        }

        return filtered
    }

    private var isFavouriteMode = false
    private var searchPhrase: String?

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
        refreshItems(limit: 10) // TODO: - add const
    }

    func refreshStocks() {
        refreshItems(limit: 10)
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

    func searchResultsUpdated(searchPhrase: String) {
        self.searchPhrase = searchPhrase.lowercased()

        DispatchQueue.main.async {
            self.view?.updateStocks()
        }
    }

    func searchFinished() {
        searchPhrase = nil
        DispatchQueue.main.async {
            self.view?.updateStocks()
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

    private func refreshItems(limit: Int) {
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
