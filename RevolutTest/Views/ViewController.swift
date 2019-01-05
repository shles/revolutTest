//
//  ViewController.swift
//  RevolutTest
//
//  Created by Артмеий Шлесберг on 26/12/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import UIKit
import SnapKit

protocol BaseUpdatingView {
    func updateBase(indexPath: IndexPath)
    func reload()
}

protocol CurrenciesView: class {
    func updateCurrencies(currencies: [Currency])
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BaseUpdatingView {
    
    private var tableView = UITableView()
    private var viewModel: RateCellModelsSource & RepeatingSource
    
    //this flag is required for preventing the keyboard from hiding, when the table scrools up while changing the base currency
    private var needsKeyboardDismissing = true

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
        tableView.allowsSelection = false
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if needsKeyboardDismissing {
            tableView.endEditing(true)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            needsKeyboardDismissing = true
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.becomeFirstResponder()
    }
    
    func updateBase(indexPath: IndexPath) {
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.becomeFirstResponder()
        }
        tableView.beginUpdates()
        needsKeyboardDismissing = false
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        tableView.endUpdates()
        CATransaction.commit()
    }
    
    func reload() {
        //This meants that if the transition of row isn't complete yet, reload should hapent only after it
        CATransaction.setCompletionBlock { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.cellForRow(at: IndexPath(item: 0, section: 0))?.becomeFirstResponder()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
