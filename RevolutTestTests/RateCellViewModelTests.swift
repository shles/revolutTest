//
//  RateCellViewModelTests.swift
//  RevolutTestTests
//
//  Created by Артмеий Шлесберг on 05/01/2019.
//  Copyright © 2019 Shlesberg. All rights reserved.
//

import XCTest
@testable import RevolutTest

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
    
    func testTextDelegateBeginEditing() {
        let textField = UITextField()
        
        viewModel.update(amount: 10)
        
        _ = viewModel.textFieldShouldBeginEditing?(textField)
        
        XCTAssertEqual(client.newBaseAmount, 870.0)
        XCTAssertEqual(client.newBaseCurrencyCode, "EUR")
    }
    
    func testTextDelegateChangeCharactersRegular() {
        let textField = UITextField()
        
        viewModel.update(amount: 10)
        
        _ = viewModel.textField?(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "87")
        
        XCTAssertEqual(client.amount, 87.0)
    }
    
    func testTextDelegateChangeCharactersEmpty() {
        let textField = UITextField()
        
        viewModel.update(amount: 10)
        
        _ = viewModel.textField?(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "87")
        
        XCTAssertEqual(client.amount, 87.0)
        
        _ = viewModel.textField?(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "")
        
        XCTAssertEqual(client.amount, 0)
    }
    
    func testTextDelegateChangeCharactersDot() {
        let textField = UITextField()
        
        viewModel.update(amount: 10)
        
        _ = viewModel.textField?(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "87")
        
        XCTAssertEqual(client.amount, 87.0)
        
        _ = viewModel.textField?(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: ".")
        
        XCTAssertEqual(client.amount, 0)
    }
    
}
