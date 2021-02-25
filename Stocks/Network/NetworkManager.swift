//
//  NetworkManager.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 23.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

protocol INetworkManager {

    func loadRequest<Model: Decodable>(request: IRequest, completion: @escaping (Result<Model?, Error>) -> Void)

}

final class NetworkManager: INetworkManager {

    let session = URLSession.shared

    func loadRequest<Model: Decodable>(request: IRequest, completion: @escaping (Result<Model, Error>) -> Void) {
        guard let urlRequest = request.urlRequest else {
            return // TODO: throws error
        }

        session.dataTask(with: urlRequest) { data, _, error in
            if let data = data,
                let responce = try? JSONDecoder().decode(Model.self, from: data) {
                completion(.success(responce))
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

}
