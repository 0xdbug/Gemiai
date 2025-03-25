//
//  ChatEntity+CoreDataProperties.swift
//  
//
//  Created by dbug on 3/24/25.
//
//

import Foundation
import CoreData


extension ChatEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatEntity> {
        return NSFetchRequest<ChatEntity>(entityName: "ChatEntity")
    }

    @NSManaged public var message: String?
    @NSManaged public var isUser: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?

}
