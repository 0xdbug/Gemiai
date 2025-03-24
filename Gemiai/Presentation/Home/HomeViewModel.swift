//
//  ViewControllerViewModel.swift
//  Gemiai
//
//  Created by dbug on 3/22/25.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleGenerativeAI

// sourcery: AutoMockable
protocol GeminiServiceProtocol {
    func sendMessage(_ message: String) -> Observable<String>
}

class HomeViewModel {
    var chats = BehaviorRelay<[Chat]>(value: [])
    
    private let geminiService: GeminiServiceProtocol
    private let chatDataManager: ChatDataProtocol
    private let disposeBag = DisposeBag()
    
    init(geminiService: GeminiServiceProtocol, chatDataManager: ChatDataProtocol) {
        self.geminiService = geminiService
        self.chatDataManager = chatDataManager
    }
    
    func fetchMessages() {
        chatDataManager.fetchMessages(onSuccess: { [self] chats in
            guard let chats = chats else { return }

            var updatedChats = self.chats.value
            updatedChats.append(contentsOf: chats.map {
                Chat(id: $0.id, message: $0.message, isUser: $0.isUser)
            })

            self.chats.accept(updatedChats)
        })
    }
    
    func sendMessage(_ message: String) {
        var currentChat = chats.value
        let userChat = Chat(id: UUID().uuidString, message: message, isUser: true)
        chatDataManager.addMessage(userChat)
        currentChat.append(userChat)
        chats.accept(currentChat)
        
        GeminiService().sendMessage(message)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }
                    
                    var currentChat = self.chats.value
                    let geminiChat = Chat(id: UUID().uuidString, message: response, isUser: false)
                    self.chatDataManager.addMessage(geminiChat)
                    
                    currentChat.append(geminiChat)
                    self.chats.accept(currentChat)
                    
                },
                onError: { error in
                    print("Error \(error)")
                }
                
            ).disposed(by: disposeBag)
    }
}
