//
//  UITabBar+Extension.swift
//
//
//  Created by Krishna Venkatramani on 23/04/2024.
//

import UIKit

public extension UITabBar {
    
    var hide: Bool {
        get { isHidden }
        set {
            
            if newValue {
                animate(.slide(.down, state: .out, duration: 0.3)) {
                    self.isHidden = newValue
                }
            } else {
                self.isHidden = newValue
                animate(.slide(.down, state: .in, duration: 0.3))
            }
        }
    }
    
}
