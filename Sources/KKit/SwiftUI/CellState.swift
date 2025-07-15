//
//  File.swift
//  KKit
//
//  Created by Krishna Venkatramani on 14/07/2025.
//

import Foundation
import SwiftUI

public struct CellState: EnvironmentKey {
    public static var defaultValue: UICellConfigurationState = .init(traitCollection: .current)
}

public extension EnvironmentValues {
    var cellState: UICellConfigurationState {
        get { self[CellState.self] }
        
        set { self[CellState.self] = newValue }
    }
}
