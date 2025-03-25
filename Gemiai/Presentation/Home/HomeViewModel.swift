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
        chatDataManager.fetchMessages()
        chatDataManager.chats.subscribe(onNext: { chat in
            self.chats.accept(chat)
        })
        .disposed(by: disposeBag)
    }
    
    func sendMessage(_ message: String) {
        let userChat = Chat(message: message, isUser: true)
        chatDataManager.addMessage(userChat)
        
        geminiService.sendMessage(message)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }
                    
                    let geminiChat = Chat(message: response, isUser: false)
                    self.chatDataManager.addMessage(geminiChat)
                    
                },
                onError: { error in
                    print("Error \(error)")
                }
                
            ).disposed(by: disposeBag)
    }
}
