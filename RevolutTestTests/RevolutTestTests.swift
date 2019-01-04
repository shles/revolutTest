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

class RateCellViewModelTests: XCTestCase {
    
    class TestBaseRateCellViewModelClient: AmountEnteringClient, BaseSelectionClient {
        
        var amount: Double?
        var newBaseCurrencyCode: String?
        var newBaseAmount: Double?
        
        func update(amount: Double) {
            self.amount = amount
        }
        
        func baseChanged(currencyCode: String, amount: Double) {
            self.newBaseCurrencyCode = currencyCode
            self.newBaseAmount = amount
        }
        
    }
    
    class TestBaseRateCellViewModelView: AmountClient {
        
        var amount: String?
        
        func update(amount: String) {
            self.amount = amount
        }
    }
    
    var viewModel: RateCellViewModel!
    var rate: RateFrom!
    var client: TestBaseRateCellViewModelClient!
    var view: TestBaseRateCellViewModelView!
    override func setUp() {
        rate = RateFrom(code: "EUR", multiplier: 87.0)
        client = TestBaseRateCellViewModelClient()
        view = TestBaseRateCellViewModelView()
        viewModel = BaseRateCellViewModel(rate: rate, newAmountClient: client)
        viewModel.associate(view: view)
    }
    
    func testName() {
        XCTAssert(viewModel.name == "EUR")
    }
    
    func testBase() {
        XCTAssert(!viewModel.isBase)
    }
    
    func testAmountUppdate() {
        viewModel.update(amount: 10.0)
        XCTAssertEqual(viewModel.amountString, "870")
    }
    
    func testRateUpdate() {
        viewModel.update(amount: 10.0)
        viewModel.update(rate: 90.0)
        XCTAssertEqual(viewModel.amountString, "900")
    }
    
    func testViewAmountupdate() {
        viewModel.update(amount: 10.0)
        XCTAssertEqual(view.amount, "870")
    }
    
    func testViewRateUpdate() {
        viewModel.update(amount: 10.0)
        viewModel.update(rate: 90.0)
        XCTAssertEqual(view.amount, "900")
    }
    
    func testRateCellViewModelAsTextDelegate() {
        let textField = UITextField()
        
        viewModel.update(amount: 10)
        
        _ = viewModel.textFieldShouldBeginEditing?(textField)
        
        XCTAssertEqual(client.newBaseAmount, 870.0)
        XCTAssertEqual(client.newBaseCurrencyCode, "EUR")
    }
}

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
