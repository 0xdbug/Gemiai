//
//  GemiaiViewModelTests.swift
//  GemiaiTests
//
//  Created by dbug on 3/23/25.
//

import XCTest
import Quick
import Nimble
import RxTest
import RxSwift
import SwiftyMocky
@testable import Gemiai

class GemiaiViewModelSpec: QuickSpec {
    override class func spec() {
        describe("HomeViewModel") {
            var sut: HomeViewModel!
            var mockGeminiService: GeminiServiceProtocolMock!
            var mockChatDataManager: ChatDataProtocolMock!
            var disposeBag: DisposeBag!
            var scheduler: TestScheduler!
            var observer: TestableObserver<[Chat]>!
            
            beforeEach {
                mockGeminiService = GeminiServiceProtocolMock()
                mockChatDataManager = ChatDataProtocolMock()
                disposeBag = DisposeBag()
                scheduler = TestScheduler(initialClock: 0)
                observer = scheduler.createObserver([Chat].self)
                
                sut = HomeViewModel(geminiService: mockGeminiService, chatDataManager: mockChatDataManager)
            }
            
            describe("fetchMessages") {
                context("when messages exist") {
                    it("should load messages from storage") {
                        // given
                        let existingChats = [
                            Chat(message: "user", isUser: true),
                            Chat(message: "ai", isUser: false),
                            Chat(message: "user", isUser: true)
                        ]
                        Given(mockChatDataManager, .chats(getter: Observable.just(existingChats)))
                        
                        // when
                        sut.chats.bind(to: observer).disposed(by: disposeBag)
                        sut.fetchMessages()
                        
                        // then
                        scheduler.start()
                        
                        expect(observer.events).to(equal([
                            .next(0, []),
                            .next(0, existingChats)
                        ]))
                        mockChatDataManager.verify(.fetchMessages())
                    }
                }
            }
            
            describe("sendMessage") {
                context("when sending a message") {
                    it("should save messages and update observable") {
                        // given
                        Given(mockGeminiService, .sendMessage(.any, willReturn: Observable.just("AI response")))
                        
                        // when
                        sut.chats.bind(to: observer).disposed(by: disposeBag)
                        sut.sendMessage("hi")
                        
                        // then
                        scheduler.start()
                        
                        mockChatDataManager.verify(.addMessage(.value(Chat(message: "hi", isUser: true))))
                        
                        let expectedChats = [
                            Chat(message: "hi", isUser: true),
                            Chat(message: "AI response", isUser: false)
                        ]
                        Given(mockChatDataManager, .chats(getter: Observable.just(expectedChats)))
                        
                        expect(observer.events.map { $0.value.element }).toNot(beEmpty())
                    }
                }
            }
        }
    }
}

