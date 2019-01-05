//
//  RevolutTestTests.swift
//  RevolutTestTests
//
//  Created by Артмеий Шлесберг on 26/12/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import XCTest
@testable import RevolutTest

class RatesTests: XCTestCase {
    
    var rate: Rate!

    func testSelfRate() {
        let currency = FakeCurrency()
        rate = SelfRate(currency: currency)
        XCTAssert(rate.code == currency.code)
        XCTAssert(rate.multiplier == 1)
    }
    
    func testRateFrom() {
        rate = RateFrom(code: "EUR", multiplier: 87.0)
        XCTAssert(rate.code == "EUR")
        XCTAssert(rate.multiplier == 87.0)
    }
    
}


