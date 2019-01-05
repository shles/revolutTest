//
// Created by Артмеий Шлесберг on 2018-12-30.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RateCell: UITableViewCell, AmountClient {

    private var nameLabel: UILabel
    private var amountField: UITextField
    private weak var viewModel: RateCellViewModel?

    override init(style: CellStyle, reuseIdentifier: String?) {

        nameLabel = UILabel()
        amountField = UITextField()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray

        self.addSubview(nameLabel)
        self.addSubview(amountField)
        self.addSubview(underlineView)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)

        amountField.placeholder = "0"
        amountField.keyboardType = .decimalPad

        nameLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 0))
            $0.trailing.equalTo(amountField.snp.leading).offset(16)
        }
        amountField.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.firstBaseline.equalTo(nameLabel)
        }
        underlineView.snp.makeConstraints {
            $0.width.centerX.equalTo(amountField)
            $0.top.equalTo(amountField.snp.bottom).offset(8)
            $0.height.equalTo(1)
        }

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.associate(view: nil)
    }

    func configured(viewModel: RateCellViewModel) -> Self {
        self.viewModel = viewModel
        self.nameLabel.text = viewModel.name
        self.amountField.text = viewModel.amountString
        viewModel.associate(view: self)
        self.amountField.delegate = viewModel
        return self
    }

    func update(amount: String) {
        if !amountField.isFirstResponder  {
            self.amountField.text = amount
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return amountField.becomeFirstResponder()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

protocol AmountClient {
    func update(amount: String)
}
