//
//  UITableViewExtensions.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import UIKit

extension UITableView {
    /// Register cell with the default cell id
    func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.cellId)
    }
    
    /// Scrolling to the last element
    func scrollToLastRow() {
        for section in stride(from: numberOfSections - 1, to: -1, by: -1) {
            // Find last section with at least one row.
            let rows = numberOfRows(inSection: section)
            if rows > 0 {
                scrollToRow(at: IndexPath(row: rows - 1, section: section), at: .bottom, animated: true)
                break
            }
        }
    }
}

extension UITableViewCell {
    /// Return a default cell Id as cell calss name
    static var cellId: String {
        return String(describing: self).lowercased()
    }
}

