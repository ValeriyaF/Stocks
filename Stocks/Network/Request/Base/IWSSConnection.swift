//
//  IWSSConnection.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 14.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

protocol IWSSConnection: IRequest {

    func subscribeToSymbolMessage(symbol: String) -> URLSessionWebSocketTask.Message?

}
