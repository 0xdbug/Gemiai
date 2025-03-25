//
//  ChatDataManager.swift
//  Gemiai
//
//  Created by dbug on 3/24/25.
//

import CoreData
import UIKit
import RxCocoa
import RxSwift

class ChatDataManager: ChatDataProtocol {
    
    private let chatsRelay: BehaviorRelay<[Chat]> = BehaviorRelay(value: [])
    var chats: Observable<[Chat]> { chatsRelay.asObservable() }
    
    func addMessage(_ chat: Chat) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newData = ChatEntity(context: context)
        newData.isUser = chat.isUser
        newData.message = chat.message
        newData.timestamp = Date()
        do {
            try context.save()
            
            var currentData = self.chatsRelay.value
            currentData.append(Chat(message: newData.message!, isUser: newData.isUser))
            self.chatsRelay.accept(currentData)
            
        } catch {
            print("error-Saving data")
        }
    }
    
    func fetchMessages() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let items = try context.fetch(ChatEntity.fetchRequest()) as? [ChatEntity]
            
            var currentData = self.chatsRelay.value
            currentData.append(contentsOf: (items?.compactMap({ entity in
                Chat(message: entity.message ?? "Invalid", isUser: entity.isUser)
            }))!)
            
            self.chatsRelay.accept(currentData)
        } catch {
            print("error-Fetching data")
        }
    }
}
