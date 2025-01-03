//
//  UIView+Buildersw.swift
//  MPC
//
//  Created by Krishna Venkatramani on 24/06/2023.
//

import Foundation
import UIKit

public typealias YAnchor = NSLayoutYAxisAnchor
public typealias XAnchor = NSLayoutXAxisAnchor

public extension UIView {
    
    @discardableResult
    func background(color: UIColor) -> UIView {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    func clippedCornerRadius(radius: CGFloat) -> UIView {
        self.clippedCornerRadius = radius
        return self
    }
    
    
    // MARK: - Individual Constraints
    
    @discardableResult
    func pinTopAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,YAnchor> = \.topAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.topAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinBottomAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,YAnchor> = \.bottomAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.bottomAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: -constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinLeadingAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,XAnchor> = \.leadingAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.leadingAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinTrailingAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,XAnchor> = \.trailingAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.trailingAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: -constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinCenterXAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,XAnchor> = \.centerXAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.centerXAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: -constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinCenterYAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,YAnchor> = \.centerYAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.centerYAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: -constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    
    // MARK: - Greater Than Constraints
    
    @discardableResult
    func pinLeadingAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView, XAnchor> = \.leadingAnchor, greaterThanOrEqualTo constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.leadingAnchor.constraint(greaterThanOrEqualTo: viewToPinTo[keyPath: anchor], constant: constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinTrailingAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView, XAnchor> = \.trailingAnchor, greaterThanOrEqualTo constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = viewToPinTo[keyPath: anchor].constraint(greaterThanOrEqualTo: trailingAnchor, constant: constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinTopAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView, YAnchor> = \.topAnchor, greaterThanOrEqualTo constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.topAnchor.constraint(greaterThanOrEqualTo: viewToPinTo[keyPath: anchor], constant: constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinBottomAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView, YAnchor> = \.bottomAnchor, greaterThanOrEqualTo constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = viewToPinTo[keyPath: anchor].constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    
    // MARK: - Lesser Than Constraints
    
    @discardableResult
    func pinLeadingAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView, XAnchor> = \.leadingAnchor, lessThanOrEqualTo constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.leadingAnchor.constraint(lessThanOrEqualTo: viewToPinTo[keyPath: anchor], constant: constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinTrailingAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView, XAnchor> = \.trailingAnchor, lessThanOrEqualTo constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = viewToPinTo[keyPath: anchor].constraint(lessThanOrEqualTo: self.trailingAnchor, constant: constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinTopAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView, YAnchor> = \.topAnchor, lessThanOrEqualTo constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.topAnchor.constraint(lessThanOrEqualTo: viewToPinTo[keyPath: anchor], constant: constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinBottomAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView, YAnchor> = \.bottomAnchor, lessThanOrEqualTo constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = viewToPinTo[keyPath: anchor].constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    
    // MARK: - Grouped Constraints
    
    @discardableResult
    func pinHorizontalAnchorsTo(_ view: UIView? = nil, leadingAnchorConstant: CGFloat, trailingAnchorConstant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [ self.leadingAnchor.constraint(equalTo: viewToPinTo.leadingAnchor, constant: leadingAnchorConstant),
                            self.trailingAnchor.constraint(equalTo: viewToPinTo.trailingAnchor, constant: -trailingAnchorConstant)]
        removeSimilarConstraints(constraints)
        NSLayoutConstraint.activate(constraints)
        return self
    }
    
    @discardableResult
    func pinHorizontalAnchorsTo(_ view: UIView? = nil, constant: CGFloat) -> UIView {
        pinHorizontalAnchorsTo(view, leadingAnchorConstant: constant, trailingAnchorConstant: constant)
    }
    
    @discardableResult
    func pinVerticalAnchorsTo(_ view: UIView? = nil, topAnchorConstant: CGFloat, bottomAnchorConstant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [ self.topAnchor.constraint(equalTo: viewToPinTo.topAnchor, constant: topAnchorConstant),  self.bottomAnchor.constraint(equalTo: viewToPinTo.bottomAnchor, constant: -bottomAnchorConstant)]
        removeSimilarConstraints(constraints)
        NSLayoutConstraint.activate(constraints)
        return self
    }
    
    @discardableResult
    func pinVerticalAnchorsTo(_ view: UIView? = nil, constant: CGFloat) -> UIView {
        pinVerticalAnchorsTo(view, topAnchorConstant: constant, bottomAnchorConstant: constant)
    }
    
    
    @discardableResult
    func pinAllAnchors(_ view: UIView? = nil, insets: UIEdgeInsets) -> UIView {
        self
            .pinHorizontalAnchorsTo(view, leadingAnchorConstant: insets.left, trailingAnchorConstant: insets.right)
            .pinVerticalAnchorsTo(view, topAnchorConstant: insets.top, bottomAnchorConstant: insets.bottom)
    }
    
    @discardableResult
    func pinAllAnchors(_ view: UIView? = nil, constant: CGFloat = 0) -> UIView {
        pinAllAnchors(view, insets: .init(by: constant))
    }
    
    @discardableResult
    func setWidthOfView(width: CGFloat, priority: UILayoutPriority = .required) -> UIView {
        let _ = self.setWidth(width: width, priority: priority)
        return self
    }
    
    @discardableResult
    func setHeightOfView(height: CGFloat, priority: UILayoutPriority = .required) -> UIView {
        let _ = self.setHeight(height: height, priority: priority)
        return self
    }
    
    @discardableResult
    func background(_ view: () -> UIView) -> UIView {
        let backgroundView = view()
        let newView = UIView()
        addSubview(self)
        addSubview(backgroundView)
        sendSubviewToBack(backgroundView)
        return newView
    }
    
    @discardableResult
    func background(_ view: UIView) -> UIView {
        background { view }
    }
    
    @discardableResult
    func overlay(_ view: () -> UIView) -> UIView {
        let overlayView = view()
        let newView = UIView()
        addSubview(self)
        addSubview(overlayView)
        return newView
    }
    
    @discardableResult
    func overlay(_ view: UIView) -> UIView {
        overlay { view }
    }
    
    var leadingConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == leadingAnchor }.first ?? .init()
    }
    
    var topConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == topAnchor }.first ?? .init()
    }
    
    var trailingConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == trailingAnchor }.first ?? .init()
    }
    
    var bottomConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == bottomAnchor }.first ?? .init()
    }
    
    var heightConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == heightAnchor }.first ?? .init()
    }
    
    var widthConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == widthAnchor }.first ?? .init()
    }
    
}
