//
// Created by Артмеий Шлесберг on 2018-12-30.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Foundation

protocol RateCellModelsSource: RepeatingSource, AmountEnteringClient, BaseSelectionClient  {

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
     func baseChanged(currencyCode: String, amount: Double)
}

protocol RepeatingSource {
    func stopFetching()
    func startFetching(forAmount amount: Double )
}

class BaseRateCellModelsSource: RateCellModelsSource{
    
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
        var fresh = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let strongSelf = self else { return }
            strongSelf.currency.fetchRates { rates in
                if fresh {
                    fresh = false
                    strongSelf.rateCellModels = ([SelfRate(currency: strongSelf.currency)] +
                        rates).map { BaseRateCellViewModel(rate: $0, newAmountClient: strongSelf) }
                    strongSelf.rateCellModels.first?.isBase = true
                    DispatchQueue.main.async {
                        strongSelf.update(amount: amount)
                        strongSelf.view.reload()
                    }
                } else {
                    for (model, rate) in zip(strongSelf.rateCellModels.dropFirst(), rates) {
                        DispatchQueue.main.async {
                            model.update(rate: rate.multiplier)
                        }
                    }
                }
            }
        }
    }

    func stopFetching() {
        timer.invalidate()
    }

    func update(amount: Double) {
        rateCellModels.forEach {
            $0.update(amount: amount)
        }
    }

    func baseChanged(currencyCode: String, amount: Double) {

        let index = rateCellModels.firstIndex {
            $0.name == currencyCode
        }
        if let index = index {
            stopFetching()
            rateCellModels.forEach { $0.isBase = false }
            rateCellModels[index].isBase = true
            currency = currencySource.currency(byCode: currencyCode)
            self.view.updateBase(indexPath: IndexPath(row: index, section: 0))
            startFetching(forAmount: amount)
        }

    }

    func associateView(view: BaseUpdatingView) {
        self.view = view
    }
}
