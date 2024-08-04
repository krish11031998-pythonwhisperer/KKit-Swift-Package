//
//  ConfigurableCell.swift
//
//
//  Created by Krishna Venkatramani on 04/08/2024.
//

import UIKit

public protocol Configurable {
    associatedtype Model: Hashable
    func configure(with model: Model)
    static var cellName: String { get }
}

public extension Configurable {
    static var cellName: String { UUID().uuidString }
}

public extension Configurable where Self: UICollectionViewCell {
    static var cellName: String { Self.name }
}

public typealias ConfigurableCollectionCell = Configurable & UICollectionViewCell
