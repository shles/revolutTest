//
//  CurrencySourceTests.swift
//  RevolutTestTests
//
//  Created by Артмеий Шлесберг on 05/01/2019.
//  Copyright © 2019 Shlesberg. All rights reserved.
//

import XCTest
@testable import RevolutTest

class CurrencySourceTests: XCTestCase {
    var currencySource: CurrencySource!
    
    override func setUp() {
        currencySource = CurrencySourceFromAPI()
    }
    
    func testCurrency() {
        let currency = currencySource.currency(byCode: "EUR")
        
        XCTAssertEqual(currency.code, "EUR")
    }
}
