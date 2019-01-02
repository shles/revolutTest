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
    func update(amount: Float)
}

protocol BaseSelectionClient {
     func baseChanged(currency: Currency)
}

class FakeRateCellsModelsSource: RateCellModelsSource, RepeatingSource, AmountEnteringClient, BaseSelectionClient {
    lazy var rateCellModels: [RateCellViewModel] = [
        BaseRateCellViewModel(rate: SelfRate(currency: FakeCurrency()), newAmountClient: self)] + FakeCurrency().rates.dropFirst().map {SelectableRateCellViewModel(rate: $0, newAmountClient: self) }

    private var view: BaseUpdatingView!
    func startFetching(fetchResultHandler: ()) {
        rateCellModels.forEach {
            $0.update(amount: 1)
        }
    }

    func stopFetching() {

    }

    func update(amount: Float) {
        rateCellModels.dropFirst().forEach {
            $0.update(amount: amount)
        }
    }

    //TODO: in real there should be changing request with base
    //it should stop repeating request, change base. MB start should come again from controller
    func baseChanged(currency: Currency) {

        let index = rateCellModels.firstIndex {
            $0.name == currency.code
        }
        //TODO: should somehow insert source. This should be handled not here. It should only give rates or there must be universal way to transform them into models
        if let index = index {
            rateCellModels = [BaseRateCellViewModel(rate: SelfRate(currency: currency), newAmountClient: self)] + currency.rates.dropFirst().map {SelectableRateCellViewModel(rate: $0, newAmountClient: self) }
            view.updateBase(indexPath: IndexPath(row: index, section: 0))
        }


    }

    func associateView(view: BaseUpdatingView) {
        self.view = view
    }
}

