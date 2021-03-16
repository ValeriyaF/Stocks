//
//  StocksInfoService.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 25.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation
import CoreData

protocol IStocksInfoService {

    var stocksInfoFilled: Bool { get }

    func refreshStocks(limit: Int, completion: @escaping (Result<[StockDataModel], Error>) -> Void)

    func loadMore(limit: Int, completion: @escaping (Result<[StockDataModel], Error>) -> Void)

    func updateFavoriteStatus(stockSymbol: String) -> [StockDataModel]

    func getLifePriceUpdate(symbol: String, completion: @escaping (Result<[StockDataModel], Error>) -> Void)

}

protocol LifePriceUpdateDelegate: class {

    func didUpdatePrice(symbol: String)

}

final class StocksInfoService: IStocksInfoService {

    // MARK: - Dependencies

    private let networkManager: INetworkManager

    // MARK: - Properties

    var lifePriceUpdateDelegates = [LifePriceUpdateDelegate]()

    private let workingQueue = DispatchQueue(label: "stocks.workingQueue", qos: .userInitiated, attributes: .concurrent)
    private var userFavorites = Set<String>()
    private lazy var lastPriceUpdatesConnection = LastPriceUpdatesConnection()

    private var stocks = [StockDataModel]()
    private var lastCompletedCount: Int = 0
    private var completedStocks: [StockDataModel] {
        let completedStocks = stocks.filter { $0.isCompleted }
        lastCompletedCount = completedStocks.count
        return completedStocks
    }

    var stocksInfoFilled: Bool {
        lastCompletedCount == stocks.count
    }

    // MARK: - Initialisation

    init(networkManager: INetworkManager) {
        self.networkManager = networkManager
    }

    func refreshStocks(limit: Int, completion: @escaping (Result<[StockDataModel], Error>) -> Void) {
        stocks = []
        lastCompletedCount = 0

        if let userData = try? (CoreDataManager.shared.fetch(entity: UserData.self) as? [UserData])?.first {
            userFavorites = Set(userData.favouriteStocks)
        } else {
            CoreDataManager.shared.save { context in
                let entity = UserData(context: context)
                entity.setValue([], forKey: (\UserData.favouriteStocks).stringValue)
            }
        }

        let djRequest = DowJonesIndexRequest()
        networkManager.loadRequest(request: djRequest) { [weak self] (result: Result<DowJonesIndexResponseData?, Error>) in
            guard let self = self else {
                return
            }

            switch result {
            case .failure(let error):
                // TODO: completion with error
                fatalError()
                break
            case .success(let response):
                self.stocks = response?.constituents.map { StockDataModel(displaySymbol: $0,
                                                                          isFavourite: self.userFavorites.contains($0))} ?? []
                self.stocks.sort(by: { $0.displaySymbol < $1.displaySymbol })
                self.loadMore(limit: limit, completion: completion)
            }
        }
    }

    func loadMore(limit: Int, completion: @escaping (Result<[StockDataModel], Error>) -> Void) {
        let border = limit + self.lastCompletedCount >= self.stocks.count
            ? self.stocks.count
            : limit + self.lastCompletedCount

        self.completeStocksInfo(indexesRange: self.lastCompletedCount ..< border,
                                completion: completion)
    }

    func updateFavoriteStatus(stockSymbol: String) -> [StockDataModel] {
        guard let index = stocks.firstIndex(where: { $0.displaySymbol == stockSymbol }) else {
            return stocks
        }

        CoreDataManager.shared.save { context in
            guard let userData = (try? context.fetch(UserData.fetchRequest()) as? [UserData])?.first else { return }

            var favorites = Set(userData.favouriteStocks)
            if favorites.contains(stockSymbol) {
                favorites.remove(stockSymbol)
            } else {
                favorites.insert(stockSymbol)
            }

            userData.setValue(Array(favorites), forKey: (\UserData.favouriteStocks).stringValue)
        }

        stocks[index].isFavourite = !stocks[index].isFavourite
        return completedStocks
    }

    func getLifePriceUpdate(symbol: String, completion: @escaping (Result<[StockDataModel], Error>) -> Void) {
        guard let message = lastPriceUpdatesConnection.subscribeToSymbolMessage(symbol: symbol) else {
            return
        }

        networkManager.sendWSSMessage(request: lastPriceUpdatesConnection,
                                      msg: message) { [weak self] (result: (Result<LastPriceUpdatesResponse?, Error>)) in
                                        guard let self = self else { return }

                                        switch result {
                                        case .success(let response):
                                            response?.data.forEach { symbolPrice in
                                                if let index = self.stocks.firstIndex(where: { $0.displaySymbol == symbolPrice.symbol }) {
                                                    self.stocks[index].currentPrice = symbolPrice.price
                                                }
                                            }

                                            completion(.success(self.completedStocks))
                                        case .failure(let error):
                                            completion(.failure(error))
                                        }
        }
    }

}

// MARK: - Private methods

extension StocksInfoService {

    private func completeStocksInfo(indexesRange: Range<Int>, completion: @escaping (Result<[StockDataModel], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()

        for i in indexesRange {
            dispatchGroup.enter()
            let stockProfile = StockProfileRequest(symbol: stocks[i].displaySymbol)
            networkManager.loadRequest(request: stockProfile) { [weak self] (result: Result<StockProfileResponseData?, Error>) in
                switch result {
                case .failure(let error):
                    // TODO: completion with error
                    fatalError()
                case .success(let response):
                    self?.stocks[i].description = response?.name ?? ""
                    self?.stocks[i].logoImageString = response?.logoURL
                    self?.stocks[i].currency  = response?.currency
                }

                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            let stockQuote = StockQuoteRequest(symbol: stocks[i].displaySymbol)
            networkManager.loadRequest(request: stockQuote) { [weak self] (result: Result<StockQuoteResponseData?, Error>) in
                switch result {
                case .failure(let error):
                    // TODO: completion with error
                    fatalError()
                case .success(let response):
                    self?.stocks[i].currentPrice = response?.currentPrice ?? 0
                    self?.stocks[i].dayOpenPrice = response?.dayOpenPrice ?? 0
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: workingQueue) { [weak self] in
            completion(.success(self?.completedStocks ?? []))
        }
    }

    private func loadStockProfile(limit: Int) {
    }

}
