//
//  UIViewController+Extension.swift
//
//
//  Created by Krishna Venkatramani on 23/04/2024.
//

import UIKit

public extension UIViewController {
    
    var isTopMostController: Bool {
        guard let nav = navigationController else { return false }
        return nav.viewControllers.count == 1 && nav.topViewController === self
    }

    func setupTransparentNavBar(color: UIColor = .clear, scrollColor: UIColor = .clear) {
        let navbarAppear: UINavigationBarAppearance = .init()
        navbarAppear.configureWithTransparentBackground()
        navbarAppear.backgroundImage = UIImage()
        navbarAppear.backgroundColor = color
        
        
        self.navigationController?.navigationBar.standardAppearance = navbarAppear
        self.navigationController?.navigationBar.compactAppearance = navbarAppear
        
        let scrollNavbarAppear: UINavigationBarAppearance = .init()
        scrollNavbarAppear.configureWithTransparentBackground()
        scrollNavbarAppear.backgroundImage = UIImage()
        scrollNavbarAppear.backgroundColor = scrollColor
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollNavbarAppear
    }
    
    
    // MARK: - TabBar
    
    func showTabBar() {
        guard let tabBar = navigationController?.tabBarController?.tabBar else { return }
        if tabBar.isHidden {
            tabBar.hide = false
        }
    }
    
    func hideTabBar() {
        guard let tabBar = navigationController?.tabBarController?.tabBar else { return }
        if !tabBar.isHidden {
            tabBar.hide = true
        }
    }
    
    
    // MARK: - NavBar
    
    func showNavbar() {
        guard let navController = navigationController else { return }
        if navController.isNavigationBarHidden {
            navController.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func hideNavbar() {
        guard let navController = navigationController else { return }
        if !navController.isNavigationBarHidden {
            navController.setNavigationBarHidden(true, animated: true)
        }
    }
    
    var isPresented: Bool {
        guard navigationController?.viewControllers.count == 1 else { return false }
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    @objc
    func popViewController(setDesiredHome: UIViewController? = nil) {
        if isPresented {
            dismiss(animated: true)
        } else {
            guard let nav = navigationController else { return }
            if let desiredVC = setDesiredHome, isTopMostController {
                nav.setViewControllers([desiredVC], animated: true)
            } else {
                nav.popViewController(animated: true)
            }
        }
    }
    
    func withNavigationController(swipable: Bool = false) -> UINavigationController {
        guard let navVC = self as? UINavigationController else {
            if swipable {
                return SwipeableNavigationController(rootViewController: self)
            } else {
                return .init(rootViewController: self)
            }
        }
        return navVC
    }
    
    
    // MARK: - Dimensions
    
    var navBarHeight: CGFloat {
        (navigationController?.navigationBar.frame.height ?? 0) + (navigationController?.additionalSafeAreaInsets.top ?? 0) +
        (navigationController?.additionalSafeAreaInsets.bottom ?? 0)
    }
    
    var tabBarHeight: CGFloat {
        navigationController?.tabBarController?.tabBar.frame.height ?? 0
    }
    
    func pushTo(target: UIViewController, asSheet: Bool = false) {
        if let nav = navigationController, !asSheet {
            nav.pushViewController(target, animated: true)
        } else {
            self.presentView(style: .sheet(), target: target.withNavigationController(), onDimissal: nil)
        }
    }
    
    var compressedSize : CGSize {
        let height = view.compressedSize.height.boundTo(lower: 200, higher: .totalHeight) - (view.safeAreaInsets.top + view.safeAreaInsets.bottom)
        let size: CGSize = .init(width: .totalWidth, height: height)
        return size
    }
    
    
    var viewHeight: CGFloat {
       compressedSize.height + .safeAreaInsets.bottom + navBarHeight
   }
    
    // MARK: - Presentation
    
    func presentView(style: PresentationStyle, addDimmingView: Bool = false, target: UIViewController, onDimissal: Callback?) {
        let presenter = PresentationController(style: style, addDimmingView: addDimmingView, presentedViewController: target, presentingViewController: self, onDismiss: onDimissal)
        target.transitioningDelegate = presenter
        target.modalPresentationStyle = .custom
        present(target, animated: true)
    }
    
    var nestedViewController: UIViewController {
        guard let nav = self as? UINavigationController,
              let last = nav.viewControllers.last
        else { return self }
        return last
    }
    
    
    // MARK: - TabBarItem
    
    @discardableResult
    func tabBarItem(_ item: MainTabModel) -> Self {
        self.tabBarItem = item.tabBarItem
        return self
    }
}
