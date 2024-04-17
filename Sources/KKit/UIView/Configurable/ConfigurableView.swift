//
//  UIView+Configurable.swift
//  KKit
//
//  Created by Krishna Venkatramani on 01/01/2024.
//

import SwiftUI


// MARK: - ConfigurableView

public typealias ConfigurableView = View & ConfigurableElement

public extension ConfigurableElement where Self: View {
    func configure(with model: Model) {
    }
}
