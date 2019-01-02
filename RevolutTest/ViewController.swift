//
//  ViewController.swift
//  RevolutTest
//
//  Created by Артмеий Шлесберг on 26/12/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BaseUpdatingView {
    
    private var tableView = UITableView()

    private var viewModel: RateCellModelsSource & RepeatingSource

    init(viewModel: RateCellModelsSource & RepeatingSource) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        viewModel.associateView(view: self)
        tableView.reloadData()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.startFetching(forAmount: 100)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.stopFetching()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rateCellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellOfType(RateCell.self, for: indexPath)
            .configured(viewModel: viewModel.rateCellModels[indexPath.row])
    }

    func updateBase(indexPath: IndexPath) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
//            self.tableView.reloadData()
            self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.becomeFirstResponder()
        }
        tableView.beginUpdates()
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        tableView.endUpdates()
        CATransaction.commit()
    }
    
    func reload() {
        let wasResponder = tableView.isFirstResponder
        tableView.reloadData()
        if wasResponder {
            tableView.cellForRow(at: IndexPath(item: 0, section: 0))?.becomeFirstResponder()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}


//TODO: rename
protocol BaseUpdatingView {
    func updateBase(indexPath: IndexPath)
    func reload()
}





protocol CurrenciesView: class {
    func updateCurrencies(currencies: [Currency])
}

protocol RepeatingSource {
    func stopFetching()
    func startFetching(forAmount amount: Double )
}


