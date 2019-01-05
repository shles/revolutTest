//
//  CurrencyFromAPITests.swift
//  RevolutTestTests
//
//  Created by Артмеий Шлесберг on 05/01/2019.
//  Copyright © 2019 Shlesberg. All rights reserved.
//

import XCTest
@testable import RevolutTest
class CurrencyFomAPITest: XCTestCase {
    
    var currency: Currency!
    
    override func setUp() {
        currency = CurrencyFromAPI(code: "EUR")
    }
    
    func testName() {
        XCTAssert(currency.code == "EUR")
    }
    
    func testRates() {
        let promise = expectation(description: "Currency rates request")
        
        currency.fetchRates { rates in
            XCTAssert(!rates.isEmpty)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5.0)
    }
    
}
