//
//  KeyPath+stringValue.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 07.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation

extension KeyPath where Root: NSObject {

    var stringValue: String {
        NSExpression(forKeyPath: self).keyPath
    }
    
}
