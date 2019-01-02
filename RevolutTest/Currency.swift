//
// Created by Артмеий Шлесберг on 2018-12-27.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Foundation

protocol Currency {

    var code: String { get }
    var rates: [Rate] { get }
}

class FakeCurrency: Currency {
    private(set) var code: String = "USD"

    lazy var rates: [Rate] = [SelfRate(currency: self), FakeEURtoUSDRate()]
}

class FakeCurrencyFromRate: Currency {

    init(rate: Rate) {
        self.code = rate.code
    }

    init(code: String) {
        self.code = code
    }

    private(set) var code: String
    private(set) lazy var rates: [Rate] = [SelfRate(currency: self), FakeUSDtoEURRate()]
}
