//
//  ConfigurableElement.swift
//  KKit
//
//  Created by Krishna Venkatramani on 01/01/2024.
//

import Foundation
import UIKit

// MARK: - ConfigurableElement

public protocol ConfigurableElement {
    associatedtype Model: Hashable
    init(model: Model)
    func configure(with model: Model)
    static var viewName: String { get }
}
