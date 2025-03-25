//
//  Chat+CoreDataProperties.swift
//  
//
//  Created by dbug on 3/24/25.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var message: String?
    @NSManaged public var isUser: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?

}
