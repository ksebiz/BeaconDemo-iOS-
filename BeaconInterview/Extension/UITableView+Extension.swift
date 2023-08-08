//
//  UITableView+Extension.swift
//  BeaconInterview
//
//  Created by Hari Krishna on 8/2/23.
//

import Foundation
import UIKit

extension UITableView {

    func register(_ nibs: [String]) {
        nibs.forEach { (nib) in
            self.register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
        }
    }

    func registerHeaders(_ nibs: [String]) {
        nibs.forEach { (nib) in
            self.register(UINib(nibName: nib, bundle: nil), forHeaderFooterViewReuseIdentifier: nib)
        }
    }

    func getDefaultCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.lightGray
        return cell
    }

  func setSectionHeaderTopPadding() {

    if #available(iOS 15, *) {
      self.sectionHeaderTopPadding = 0
    } else {
      self.tableHeaderView = .init(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
    }
  }

}

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}
