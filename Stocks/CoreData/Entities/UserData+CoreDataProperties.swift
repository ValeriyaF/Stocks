//
//  UserData+CoreDataProperties.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 07.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//
//

import Foundation
import CoreData

extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var favouriteStocks: [String]

}
