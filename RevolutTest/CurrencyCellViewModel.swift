//
// Created by Артмеий Шлесберг on 2018-12-30.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Foundation
import UIKit

protocol RateCellViewModel: Named, UITextFieldDelegate, AmountEnteringClient {
    func associate(view: AmountClient)
}

class BaseRateCellViewModel: NSObject, RateCellViewModel {
    
    private var view: AmountClient!
    private var rate: Float
    fileprivate var newAmountClient: AmountEnteringClient & BaseSelectionClient

    let name: String


    init(rate: Rate, newAmountClient: AmountEnteringClient & BaseSelectionClient) {
        self.name = rate.code
        self.rate = rate.multiplier
        self.newAmountClient = newAmountClient
    }

    func associate(view: AmountClient) {
        self.view = view
    }

    func update(amount: Float) {
        if amount == 0 {
            view.update(amount: "")
        } else {
            view.update(amount: "\(amount * rate)")
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let newStr = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) {
           if let amount = Float(newStr) {
                newAmountClient.update(amount: amount)
                return true
            }
            if newStr == "" {
                newAmountClient.update(amount: 0)
                return true
            }
            if newStr.starts(with: "."), let amount = Float("0" + newStr) {
                newAmountClient.update(amount: amount)
                return true
            }
        }
        return false
    }

}

class SelectableRateCellViewModel: BaseRateCellViewModel {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        newAmountClient.baseChanged(currency: FakeCurrencyFromRate(code: name))
        return true
    }

}



protocol Named {
    var name: String {get}
}


