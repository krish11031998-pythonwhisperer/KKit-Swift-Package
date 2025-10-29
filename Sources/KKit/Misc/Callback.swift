//
//  File.swift
//  Pods-SUIKit_Example
//
//  Created by Krishna Venkatramani on 27/12/2023.
//

import Foundation
import UIKit

// MARK: - Callback

public typealias Callback = () -> Void
public typealias CallbackWithCell = (UIView) -> Void


// MARK: - ActionProvider

public protocol ActionProvider {
    var action: Callback? { get set }
}

public protocol ActionProviderWithCell {
    var actionWithCell: CallbackWithCell? { get set }
}
