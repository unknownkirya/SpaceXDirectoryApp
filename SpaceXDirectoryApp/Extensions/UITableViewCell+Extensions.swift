//
//  TableViewCell.swift
//  SpaceXDirectoryApp
//
//  Created by Кирилл Бережной on 11.12.2023.
//

import Foundation
import UIKit

// MARK: - UITableViewCell
extension UITableViewCell {
    
    // MARK: - Static property
    static var identifier: String {
        String(describing: self)
    }
}
