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
    @NSManaged public var url: String
    @NSManaged public var imageURL: String

    
}

extension ItemEntity : Identifiable {

}
