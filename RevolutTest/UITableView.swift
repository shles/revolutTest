//
// Created by Артмеий Шлесберг on 2018-12-30.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Foundation
import UIKit
extension UITableView {

    func dequeueReusableCellOfType<CellType: UITableViewCell>(_ type: CellType.Type, for indexPath: IndexPath) -> CellType {
        let cellName = String(describing: type)
        register(CellType.self, forCellReuseIdentifier: cellName)
        return dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! CellType
    }
}