//
//  NetworkManager.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 23.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

protocol INetworkManager {

    func loadRequest<Model: Decodable>(request: IRequest,
                                       completion: @escaping (Result<Model?, Error>) -> Void)

    func sendWSSMessage<T: IWSSConnection, Model: Decodable>(request: T,
                                                             msg: URLSessionWebSocketTask.Message,
                                                             completion: @escaping (Result<Model?, Error>) -> Void)

    func closeConnection<T: IWSSConnection>(request: T)

}

final class NetworkManager {

    // MARK: - Properties

    private let session = URLSession.shared
    private let wssWorkingQueue = DispatchQueue(label: "stocks.networkManagerworkingQueue", qos: .default)

    private lazy var decoder = JSONDecoder()

    private var webSocketTasks = [String: URLSessionWebSocketTask]()

    deinit {
        webSocketTasks.forEach { $0.value.cancel() }
    }

}

// MARK: - INetworkManager

extension NetworkManager: INetworkManager {

    func loadRequest<Model: Decodable>(request: IRequest,
                                       completion: @escaping (Result<Model?, Error>) -> Void) {
        guard let urlRequest = request.urlRequest else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        session.dataTask(with: urlRequest) { [weak self] data, _, error in
            if let error = error {
                completion(.failure(error))
            }

            if let data = data,
                let response = try? self?.decoder.decode(Model.self, from: data) {
                completion(.success(response))
            } else {
                completion(.failure(NetworkError.decodingError))
            }

        }.resume()
    }

    func sendWSSMessage<T: IWSSConnection, Model: Decodable>(request: T,
                                                             msg: URLSessionWebSocketTask.Message,
                                                             completion: @escaping (Result<Model?, Error>) -> Void) {
        let taskID = String(describing: request.self)
        if webSocketTasks[taskID] == nil {
            do {
                try openWSSConnection(request: request, taskID: taskID)
            } catch {
                completion(.failure(error))
                return
            }
        }

        guard let webSocketTask = webSocketTasks[taskID] else {
            completion(.failure(NetworkError.unexpectedError))
            return
        }

        webSocketTask.send(msg) { error in
            if let error = error {
                completion(.failure(error))
            }
        }

        wssWorkingQueue.async {
            self.receiveWSS(task: webSocketTask, completion: completion)
        }
    }

    func closeConnection<T: IWSSConnection>(request: T) {
        let taskID = String(describing: request.self)
        if webSocketTasks[taskID] != nil {
            webSocketTasks[taskID]?.cancel()
            webSocketTasks[taskID] = nil
        }
    }

}

// MARK: - Private methods

extension NetworkManager {

    private func openWSSConnection(request: IRequest, taskID: String) throws {
        guard let urlRequest = request.urlRequest else {
            throw NetworkError.invalidRequest
        }

        let webSocketTask = session.webSocketTask(with: urlRequest)
        webSocketTask.resume()
        webSocketTasks[taskID] = webSocketTask

        sendWSSPing(task: webSocketTask)
    }

    private func sendWSSPing(task: URLSessionWebSocketTask) {
        task.sendPing { error in
            if let error = error {
//                assertionFailure("Sending ping failed: \(error)")
            }

            self.wssWorkingQueue.asyncAfter(deadline: .now() + 10) {
                self.sendWSSPing(task: task)
            }
        }
    }

    private func receiveWSS<Model: Decodable>(task: URLSessionWebSocketTask,
                                              completion: @escaping (Result<Model?, Error>) -> Void) {
        task.receive { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let msg):
                switch msg {
                case .data(let data):
                    if let response = try? self.decoder.decode(Model.self, from: data) {
                        completion(.success(response))
                    } else {
                        completion(.failure(NetworkError.decodingError))
                    }
                case .string(let string):
                    if let response = try? self.decoder.decode(Model.self, from: Data(string.utf8)) {
                        completion(.success(response))
                    } else {
                        completion(.failure(NetworkError.decodingError))
                    }
                @unknown default:
                    completion(.failure(NetworkError.unexpectedError))
                }

                self.receiveWSS(task: task, completion: completion)
            case .failure(let error):
                break
//                completion(.failure(error))
            }
        }
    }

}
