//
//  UITableView.swift
//  NearBy
//
//  Created by Khaled Elshamy on 06/10/2021.
//

import UIKit


protocol ReusableView {
    static var defaultReuseIdentifier : String { get }
}

extension ReusableView where Self: UITableViewCell {
    static var defaultReuseIdentifier : String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}

extension UITableView {
    
    func register<Cell: UITableViewCell>(_: Cell.Type) {
        let bundle = Bundle(for: Cell.self)
        let nib = UINib(nibName: Cell.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: Cell.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.defaultReuseIdentifier, for:  indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(Cell.defaultReuseIdentifier)")
        }
        return cell
    }
}
