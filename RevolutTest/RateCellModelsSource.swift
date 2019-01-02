//
// Created by Артмеий Шлесберг on 2018-12-30.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Foundation

protocol RateCellModelsSource {

    var rateCellModels: [RateCellViewModel] {get}

    func associateView(view: BaseUpdatingView)
}

protocol AmountEnteringClient {
    func update(amount: Double)
}

protocol RateUpdatingClient {
    func update(rate: Double)
}

protocol BaseSelectionClient {
     func baseChanged(currencyCode: String, amountString: String)
}

class RateCellsModelsSource: RateCellModelsSource, RepeatingSource, AmountEnteringClient, BaseSelectionClient {
    

    var rateCellModels: [RateCellViewModel] = []

    private var view: BaseUpdatingView!
    private var currencySource: CurrencySource
    private var currency: Currency
    private var timer = Timer()

    init(currencySource: CurrencySource) {
        //TODO: set amount
        self.currencySource = currencySource
        self.currency = currencySource.currency(byCode: "EUR")
    }
    func startFetching(forAmount amount: Double = 0) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let strongSelf = self else { return }
            strongSelf.currency.fetchRates { rates in
                if strongSelf.rateCellModels.count != rates.count + 1 {
                    strongSelf.rateCellModels = [BaseRateCellViewModel(rate: SelfRate(currency: strongSelf.currency), newAmountClient: strongSelf)] +
                        rates.map { SelectableRateCellViewModel(rate: $0, newAmountClient: strongSelf) }
                    strongSelf.update(amount: amount)
                    strongSelf.view.reload()
                } else {
                    for (model, rate) in zip(strongSelf.rateCellModels.dropFirst(), rates) {
                        model.update(rate: rate.multiplier)
                    }
                }
            }
        }
    }

    func stopFetching() {
        timer.invalidate()
    }

    func update(amount: Double) {
        rateCellModels.dropFirst().forEach {
            $0.update(amount: amount)
        }
    }

    func baseChanged(currencyCode: String, amountString: String) {

        let index = rateCellModels.firstIndex {
            $0.name == currencyCode
        }
        if let index = index {
            stopFetching()
            currency = currencySource.currency(byCode: currencyCode)
            self.view.updateBase(indexPath: IndexPath(row: index, section: 0))
            rateCellModels = []
            
            startFetching(forAmount: Double(amountString) ?? 0)
        }

    }

    func associateView(view: BaseUpdatingView) {
        self.view = view
    }
}

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

