//
//  SwipableViewController.swift
//
//
//  Created by Krishna Venkatramani on 23/04/2024.
//

import UIKit

class SwipeableNavigationController: UINavigationController {

    var isPushingViewController = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushingViewController = true
        super.pushViewController(viewController, animated: animated)
    }
}

extension SwipeableNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer is UIScreenEdgePanGestureRecognizer else { return true }
        return viewControllers.count > 1 && !isPushingViewController
    }
}


extension SwipeableNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isPushingViewController = false
    }
}
