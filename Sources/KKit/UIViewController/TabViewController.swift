//
//  TabViewController.swift
//
//
//  Created by Krishna Venkatramani on 23/04/2024.
//

import UIKit

public protocol TabViewController {
    var tabName: String { get }
    var iconAsset: ImageSource { get }
    var tabTitle: String { get }
}

public extension TabViewController where Self: UIViewController {
    var tabName: String { Self.name }
    
}
