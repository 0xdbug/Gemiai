//
//  ChatDataProtocol.swift
//  Gemiai
//
//  Created by dbug on 3/24/25.
//

import CoreData
import RxSwift

// sourcery: AutoMockable
//sourcery: typealias = "Chat = Gemiai.Chat"
protocol ChatDataProtocol {
    var chats: Observable<[Chat]> { get }
    func addMessage(_ chat: Chat)
    func fetchMessages()
}
