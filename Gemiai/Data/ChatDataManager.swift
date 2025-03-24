//
//  ChatDataManager.swift
//  Gemiai
//
//  Created by dbug on 3/24/25.
//

import CoreData
import UIKit

class ChatDataManager: ChatDataProtocol {
    func addMessage(_ chat: Chat) {
        DispatchQueue.main.async { // is this bad practice?
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newData = ChatEntity(context: context)
            newData.isUser = chat.isUser
            newData.message = chat.message
            newData.timestamp = Date()
            do {
                try context.save()
            } catch {
                print("error-Saving data")
            }
        }
    }
    
    func fetchMessages(onSuccess: @escaping ([Chat]?) -> Void) {
        DispatchQueue.main.async {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                let items = try context.fetch(ChatEntity.fetchRequest()) as? [ChatEntity]
                let chatItems = items?.compactMap({ entity in
                    Chat(id: entity.id?.uuidString ?? UUID().uuidString, message: entity.message ?? "Invalid", isUser: entity.isUser)
                })
                onSuccess(chatItems)
            } catch {
                print("error-Fetching data")
            }
        }
    }
}
