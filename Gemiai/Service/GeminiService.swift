//
//  GeminiService.swift
//  Gemiai
//
//  Created by dbug on 3/22/25.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleGenerativeAI

/// https://ai.google.dev/api?lang=swift
class GeminiService: GeminiServiceProtocol {
    private let model: GenerativeModel
    private let chatHistory = BehaviorRelay<[String]>(value: [""])
    
    init() {
        let config = GenerationConfig(
            temperature: 1,
            topP: 0.95,
            topK: 40,
            maxOutputTokens: 8192,
            responseMIMEType: "text/plain"
        )
        
//        guard let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] else {
//            fatalError("Add GEMINI_API_KEY as an Environment Variable in your app's scheme.")
//        }
        let apiKey = "AIzaSyDSmmuDAin5TiFVjxlVuS6-fhV7lUD1PDU" // already deleted
        
        self.model = GenerativeModel(
            name: "gemini-2.0-flash",
            apiKey: apiKey,
            generationConfig: config
        )
    }
    
    func sendMessage(_ message: String) -> Observable<String> {
        return Observable.create { observer in
            Task {
                do {
                    let chatInstance = self.model.startChat()
                    let response = try await chatInstance.sendMessage(message)
                    
                    if let responseText = response.text {
                        observer.onNext(responseText)
                        observer.onCompleted()
                    } else {
                        observer.onError(NSError(domain: "GeminiService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Empty response"]))
                    }
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
