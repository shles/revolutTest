//
// Created by Артмеий Шлесберг on 2018-12-27.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol Currency {
    var code: String { get }
    func fetchRates(completion: @escaping  ([Rate]) -> ())
}

class FakeCurrency: Currency {
    private(set) var code: String = "USD"

    lazy var rates: [Rate] = [FakeEURtoUSDRate()]

    func fetchRates(completion: @escaping ([Rate]) -> ()) {
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

    func fetchRates(completion: @escaping ([Rate]) -> ()) {
        completion(rates)
    }
}


class CurrencyFromAPI: Currency {
    
    var code: String

    init(code: String) {
        self.code = code
    }

    func fetchRates(completion: @escaping ([Rate]) -> ()) {
        guard let url = URL(string: "https://revolut.duckdns.org/latest?base=\(code)") else {
            print("URL error")
            return
        }

        let queue = DispatchQueue(label: "revolut.currency", qos: .background, attributes: .concurrent)
        Alamofire.request(url)
            .responseJSON(queue: queue, completionHandler: { response in
                switch response.result {
                case .success(let value):

                    let json = JSON(value)
                    let rates = json["rates"].map{ (arg: (String, JSON)) -> Rate in
                        
                        let (key, value) = arg
                        return RateFrom(code: key, multiplier: value.doubleValue)
                    }
                    completion(rates)

                case .failure(let error):

                    print("Fetching rates error: \(error)")
                }
            }
        )
    }
}

