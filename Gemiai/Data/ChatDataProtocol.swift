//
//  ChatDataProtocol.swift
//  Gemiai
//
//  Created by dbug on 3/24/25.
//

import CoreData

// sourcery: AutoMockable
protocol ChatDataProtocol {
    func addMessage(_ chat: Chat)
    func fetchMessages(onSuccess: @escaping ([Chat]?) -> Void)
}
