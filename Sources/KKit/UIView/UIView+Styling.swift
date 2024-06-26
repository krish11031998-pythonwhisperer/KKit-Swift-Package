//
//  UIView+Styling.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 20/09/2022.
//

import Foundation
import UIKit

//MARK: - Corners
public enum CornerRadius {
    case top
    case bottom
    case all
    
    var corners: CACornerMask {
        switch self {
        case .top: return [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        case .bottom: return [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        case .all: return [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }
    }
}


//MARK: - UIView+Styling
public extension UIView {
    func border(color: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat? = nil) {
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
        
        if let validCornerRadius = cornerRadius {
            self.cornerRadius = validCornerRadius
        }
    }
    
    var defaultBlurStyle: UIBlurEffect.Style {
        userInterface == .light ? .systemThinMaterialLight : .systemUltraThinMaterialDark
    }
    
    @discardableResult
    func addBlurView(_ _style: UIBlurEffect.Style? = nil) -> UIVisualEffectView {
        let style = _style ?? defaultBlurStyle
        let blur = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blur)
        self.addSubview(blurView)
        blurView.fillSuperview()
        sendSubviewToBack(blurView)
        return blurView
    }
    
    func add3DShadow(size: CGSize = .init(width: 1, height: 1),
                     color: UIColor = .black,
                     opacity: Float = 1,
                     radius: CGFloat = 0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = size
        self.layer.shadowRadius = radius
    }
    
    func addShadowBackground(inset: UIEdgeInsets = .zero, cornerRadius: CGFloat = 8) {
        let view = UIView()
        view.addShadow(for: .small)
        view.border(color: .clear, borderWidth: 1, cornerRadius: cornerRadius)
        addSubview(view)
        sendSubviewToBack(view)
        view.fillSuperview()
    }
}


//MARK: - UIView+Shadow
public extension UIView {
    
    enum ShadowType {
        case small, medium, large, highlight
    }
    
    func addShadow(color: UIColor = .black.withAlphaComponent(0.3),
                   for type: ShadowType) {
        self.layer.shadowColor = color.cgColor
        switch type {
        case .small:
            self.layer.shadowOpacity = 0.03
            self.layer.shadowOffset = .init(width: 0, height: 0)
        case .medium:
            self.layer.shadowOpacity = 0.05
            self.layer.shadowOffset = .init(width: 0, height: 0)
        case .large:
            self.layer.shadowOpacity = 0.12
            self.layer.shadowOffset = .init(width: 0, height: 0)
        case .highlight:
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = .init(width: 0, height: 0)
        }
        self.layer.shadowRadius = 30
    }
    
    func removeShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 0
    }
}
