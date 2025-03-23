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
        
        // sendMessage with any message should return mock response
        describe("sendMessage") {
            var mockService: GeminiServiceProtocolMock!
            var disposeBag: DisposeBag!
            var scheduler: TestScheduler!
            var observer: TestableObserver<String>!
            
            beforeEach {
                mockService = GeminiServiceProtocolMock()
                
                disposeBag = DisposeBag()
                scheduler = TestScheduler(initialClock: 0)
                observer = scheduler.createObserver(String.self)
            }
            
            context("with any message") {
                it("should return mock response") {
                    Given(mockService, .sendMessage(.any, willReturn: Observable.just("mock response")))

                    let test = mockService.sendMessage("test")
                    
                    test.bind(to: observer).disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    expect(observer.events).to(equal([
                        .next(0, "mock response"),
                        .completed(0)
                    ]))
                }
            }
        }
    }
}
