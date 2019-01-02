//
// Created by Артмеий Шлесберг on 2018-12-27.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Foundation

protocol Currency {

    var code: String { get }
    func fetchRates(completion: ([Rate]) -> ())
}

class FakeCurrency: Currency {
    private(set) var code: String = "USD"

    lazy var rates: [Rate] = [FakeEURtoUSDRate()]

    func fetchRates(completion: ([Rate]) -> ()) {
        completion(rates)
    }
}

class FakeCurrencyFromRate: Currency {

    init(rate: Rate) {
        self.code = rate.code
    }

    init(code: String) {
        self.code = code
    }

    private(set) var code: String
    private(set) lazy var rates: [Rate] =  [FakeUSDtoEURRate()]

    func fetchRates(completion: ([Rate]) -> ()) {
        completion(rates)
    }
}
