//
//  Stock+CoreDataProperties.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 06.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//
//

import Foundation
import CoreData

extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var displaySymbol: String?
    @NSManaged public var nameDescription: String?
    @NSManaged public var currentPrice: NSNumber?

}
