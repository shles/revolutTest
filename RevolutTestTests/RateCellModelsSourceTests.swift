//
//  RateCellModelsSourceTests.swift
//  RevolutTestTests
//
//  Created by Артмеий Шлесберг on 05/01/2019.
//  Copyright © 2019 Shlesberg. All rights reserved.
//

import XCTest
@testable import RevolutTest

class RateCellsModelsSourceTests: XCTestCase {
    
    class TestBaseUpdatingView: BaseUpdatingView {
        
        var reloadPromise: XCTestExpectation
        
        init(reloadPromise: XCTestExpectation) {
            self.reloadPromise = reloadPromise
        }
        
        var newBaseIndex: Int?
        
        func updateBase(indexPath: IndexPath) {
            newBaseIndex = indexPath.row
        }
        
        func reload() {
            reloadPromise.fulfill()
        }
    }
    var promise: XCTestExpectation!
    var modelsSource: RateCellModelsSource!
    var view: TestBaseUpdatingView!
    override func setUp() {
        promise = expectation(description: "reload")
        promise.assertForOverFulfill = false
        view = TestBaseUpdatingView(reloadPromise: promise)
        modelsSource = BaseRateCellModelsSource(currencySource: FakeCurrencySource())
        modelsSource.associateView(view: view)
    }
    
    func testStartFetching() {
        modelsSource.startFetching(forAmount: 0)
        wait(for: [promise], timeout: 2.0)
    }
    
    func testModels() {
        modelsSource.startFetching(forAmount: 0)
        wait(for: [promise], timeout: 2.0)
        XCTAssertFalse(modelsSource.rateCellModels.isEmpty)
    }
    
    func testAmountUpdate() {
        modelsSource.startFetching(forAmount: 0)
        wait(for: [promise], timeout: 2.0)
        XCTAssertFalse(modelsSource.rateCellModels.isEmpty)
        modelsSource.update(amount: 10.0)
        
        XCTAssertEqual(modelsSource.rateCellModels.first?.amountString, "10")
        
        modelsSource.baseChanged(currencyCode: "USD", amount: 10)
    }
    
    func testBaseChanged() {
        modelsSource.startFetching(forAmount: 0)
        wait(for: [promise], timeout: 2.0)
        XCTAssertFalse(modelsSource.rateCellModels.isEmpty)
        modelsSource.baseChanged(currencyCode: "USD", amount: 10)
        XCTAssertEqual(view.newBaseIndex, 1)
    }
}
