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
    private let disposeBag = DisposeBag()
    
    init(geminiService: GeminiServiceProtocol) {
        self.geminiService = geminiService
    }
    
    func sendMessage(_ message: String) {
        var currentChat = chats.value
        let userChat = Chat(id: UUID().uuidString, message: message, isUser: true)
        currentChat.append(userChat)
        chats.accept(currentChat)
        
        GeminiService().sendMessage(message)
            .subscribe(
                onNext: { [weak self] response in
                    
                    var currentChat = self?.chats.value
                    let geminiChat = Chat(id: UUID().uuidString, message: response, isUser: false)
                    currentChat?.append(geminiChat)
                    self?.chats.accept(currentChat!)
                    
                },
                onError: { error in
                    print("Error \(error)")
                }
                
            ).disposed(by: disposeBag)
    }
}
