//
//  Index+CoreDataProperties.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 06.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//
//

import Foundation
import CoreData

extension Index {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Index> {
        return NSFetchRequest<Index>(entityName: "Index")
    }

    @NSManaged public var symbols: [String]?

}
