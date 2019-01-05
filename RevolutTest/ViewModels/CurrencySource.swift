//
//  CurrencySource.swift
//  RevolutTest
//
//  Created by Артмеий Шлесберг on 04/01/2019.
//  Copyright © 2019 Shlesberg. All rights reserved.
//

import Foundation


protocol CurrencySource {
    func currency(byCode code: String) -> Currency
}

class FakeCurrencySource: CurrencySource {
    func currency(byCode code: String) -> Currency {
        if code == "USD" {
            return FakeCurrency()
        }
        return FakeCurrencyFromRate(code: "EUR")
    }
}

class CurrencySourceFromAPI: CurrencySource {
    func currency(byCode code: String) -> Currency {
        return CurrencyFromAPI(code: code)
    }
}
