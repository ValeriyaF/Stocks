//
//  NetworkError.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 14.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

enum NetworkError: Error {

    case unexpectedError
    case invalidRequest
    case decodingError

}
