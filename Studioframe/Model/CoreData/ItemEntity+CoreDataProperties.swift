//
//  ItemEntity+CoreDataProperties.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 23/12/2021.
//
//

import Foundation
import CoreData


extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var title: String

}

extension ItemEntity : Identifiable {

}
