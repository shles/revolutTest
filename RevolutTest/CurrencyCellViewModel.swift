//
// Created by Артмеий Шлесберг on 2018-12-30.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Foundation
import UIKit

protocol RateCellViewModel: UITextFieldDelegate, AmountEnteringClient, RateUpdatingClient {
    var name: String {get}
    var amountString: String {get}
    var isBase: Bool {get set}
    func associate(view: AmountClient?)
}

class BaseRateCellViewModel: NSObject, RateCellViewModel {
    
    var isBase: Bool = false
    
    private var view: AmountClient?
    private var currentRate: Double
    private var currentAmount: Double
    fileprivate var newAmountClient: AmountEnteringClient & BaseSelectionClient

    private var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let name: String

    init(rate: Rate, newAmountClient: AmountEnteringClient & BaseSelectionClient) {
        self.name = rate.code
        self.currentAmount = 0
        self.currentRate = rate.multiplier
        self.newAmountClient = newAmountClient
    }

    func associate(view: AmountClient?) {
        self.view = view
    }

    func update(amount: Double) {
        currentAmount = amount
        updateViewAmount()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let newStr = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) {
           if let amount = amountFormatter.number(from: newStr)?.doubleValue {
                newAmountClient.update(amount: amount)
                return true
            }
            if newStr == "" || newStr == "." {
                newAmountClient.update(amount: 0)
                return true
            }
        }
        return false
    }

    func update(rate: Double) {
        self.currentRate = rate
        updateViewAmount()
    }
    
    private func updateViewAmount() {
        guard let view = view else { return }
        if currentAmount * currentRate == 0 {
            view.update(amount: "")
        } else {
            view.update(amount: amountFormatter.string(from: NSNumber(value: currentAmount * currentRate)) ?? "")
        }
        
    }

    var amountString: String  {
        if currentAmount * currentRate == 0 {
            return  ""
        } else {
            return  amountFormatter.string(from: NSNumber(value: currentAmount * currentRate)) ?? ""
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !isBase {
            newAmountClient.baseChanged(currencyCode: name, amount: currentAmount * currentRate)
            return false
        }
        return true
    }
}
