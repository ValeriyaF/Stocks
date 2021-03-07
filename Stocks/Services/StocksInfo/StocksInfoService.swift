//
//  StocksInfoService.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 25.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

protocol IStocksInfoService {

    var stocksInfoFilled: Bool { get }

    func refreshStocks(limit: Int, completion: @escaping (Result<[StockDataModel], Error>) -> Void)

    func loadMore(limit: Int, completion: @escaping (Result<[StockDataModel], Error>) -> Void)

}

final class StocksInfoService: IStocksInfoService {

    // MARK: - Dependencies

    let networkManager: INetworkManager

    private let workingQueue = DispatchQueue(label: "stocks.workingQueue", qos: .userInitiated, attributes: .concurrent)
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

        let djRequest = DowJonesIndexRequest()
        networkManager.loadRequest(request: djRequest) { [weak self] (result: Result<DowJonesIndexResponseData?, Error>) in
            guard let self = self else {
                return
            }

            switch result {
            case .failure(let error):
                // TODO: completion with error
                break
            case .success(let response):
                self.stocks = response?.constituents.map { StockDataModel(displaySymbol: $0) } ?? []
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
                    break
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
                    break
                case .success(let response):
                    self?.stocks[i].currentPrice = response?.currentPrice ?? 0
                    if let currentPrice = response?.currentPrice,
                        let dayOpenPrice = response?.dayOpenPrice {
                        self?.stocks[i].dayDelta = currentPrice - dayOpenPrice
                        self?.stocks[i].dayDeltaPersent = 100 * (currentPrice - dayOpenPrice) / dayOpenPrice
                    }
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
