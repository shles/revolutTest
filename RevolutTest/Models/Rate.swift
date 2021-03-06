//
// Created by Артмеий Шлесберг on 2018-12-30.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Rate {
    var code: String {get}
    var multiplier: Double {get}
}

class RateFrom: Rate {
    var code: String
    var multiplier: Double

    init(code: String, multiplier: Double) {
        self.code = code
        self.multiplier = multiplier
    }
}

class SelfRate: Rate {

    init(currency: Currency) {
        code = currency.code
    }

    private(set) var code: String
    private(set) var multiplier: Double = 1
}

class FakeEURtoUSDRate: Rate {
    private(set) var code: String = "EUR"
    private(set) var multiplier: Double = 0.8623
}

class FakeUSDtoEURRate: Rate {
    private(set) var code: String = "USD"
    private(set) var multiplier: Double = 1.1596892033
}
