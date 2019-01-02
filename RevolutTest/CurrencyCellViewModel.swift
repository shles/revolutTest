//
// Created by Артмеий Шлесберг on 2018-12-30.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Foundation
import UIKit

protocol RateCellViewModel: Named, UITextFieldDelegate, AmountEnteringClient, RateUpdatingClient {
    func associate(view: AmountClient)
}

class BaseRateCellViewModel: NSObject, RateCellViewModel {
    
    private var view: AmountClient!
    private var currentRate: Double
    private var currentAmount: Double
    fileprivate var newAmountClient: AmountEnteringClient & BaseSelectionClient

    let name: String

    init(rate: Rate, newAmountClient: AmountEnteringClient & BaseSelectionClient) {
        self.name = rate.code
        self.currentAmount = 0
        self.currentRate = rate.multiplier
        self.newAmountClient = newAmountClient
    }

    func associate(view: AmountClient) {
        self.view = view
    }

    func update(amount: Double) {
        currentAmount = amount
        updateViewAmount()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let newStr = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) {
           if let amount = Double(newStr) {
                newAmountClient.update(amount: amount)
                return true
            }
            if newStr == "" {
                newAmountClient.update(amount: 0)
                return true
            }
            if newStr.starts(with: "."), let amount = Double("0" + newStr) {
                newAmountClient.update(amount: amount)
                return true
            }
        }
        return false
    }

    func update(rate: Double) {
        self.currentRate = rate
        updateViewAmount()
    }
    
    private var amountForamtter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    

    private func updateViewAmount() {
        guard let view = view else { return }
        if currentAmount == 0 {
            view.update(amount: "")
        } else {
            view.update(amount: amountForamtter.string(from: NSNumber(value: currentAmount * currentRate)) ?? "")
        }
    }
}

class SelectableRateCellViewModel: BaseRateCellViewModel {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        newAmountClient.baseChanged(currencyCode: name, amountString: textField.text ?? "")
        return true
    }

}

protocol Named {
    var name: String {get}
}


