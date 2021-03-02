//
//  StocksInfoService.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 25.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

protocol IStocksInfoService {

    func loadStocks(limit: Int, completion: @escaping (Result<DowJonesIndexResponceData?, Error>) -> Void)

}

final class StocksInfoService: IStocksInfoService {

    // MARK: - Dependencies

    let networkManager: INetworkManager

    // MARK: - Initialisation

    init(networkManager: INetworkManager) {
        self.networkManager = networkManager
    }

    func loadStocks(limit: Int, completion: @escaping (Result<DowJonesIndexResponceData?, Error>) -> Void) {
        let djRequest = DowJonesIndexRequest()

        networkManager.loadRequest(request: djRequest, completion: completion)
    }

}
