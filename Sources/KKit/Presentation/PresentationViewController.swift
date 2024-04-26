//
//  PresentationViewController.swift
//  
//
//  Created by Krishna Venkatramani on 23/04/2024.
//

import UIKit
import Combine

//MARK: - PresentationController
public class PresentationController: UIPresentationController {
    
    private var onDismiss: Callback?
    public var style: PresentationStyle
    private let addDimmingView: Bool?
    private var bag: Set<AnyCancellable> = .init()
    
    private lazy var dimmingView: UIView =  {
        let view = UIView()
        view.backgroundColor = dimmingColor.withAlphaComponent(0.3)
        view.layer.opacity = 0
        return view
    }()
    private let dimmingColor: UIColor
    
    public init(style: PresentationStyle, dimmingColor: UIColor, addDimmingView: Bool? = nil, presentedViewController: UIViewController, presentingViewController: UIViewController?, onDismiss: Callback?) {
        self.addDimmingView = addDimmingView
        self.style = style
        self.onDismiss = onDismiss
        self.dimmingColor = dimmingColor
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeOnTap)))
        bindKeyboardAdjustment()
    }
    
    convenience init(style: PresentationStyle, addDimmingView: Bool? = nil, presentedViewController: UIViewController, presentingViewController: UIViewController?, onDismiss: Callback?) {
        self.init(style: style, dimmingColor: .clear, addDimmingView: addDimmingView, presentedViewController: presentedViewController, presentingViewController: presentingViewController, onDismiss: onDismiss)
    }
    
    var nestedViewController: UIViewController? {
        guard let navController = presentedViewController as? UINavigationController else { return presentedViewController }
        return navController.viewControllers.last
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        if let frame = style.frameOfPresentedView {
            return frame
        }
        
        guard let bounds = containerView?.bounds, let container = nestedViewController else {
            return CGSize(width: .totalWidth, height: .totalHeight).bounds
        }
        
        var frame = bounds
        let height = container.preferredContentHeight
        frame.origin.y = bounds.height - height
        frame.size.height = height
        return frame
        
    }
    
    
    
    public override func presentationTransitionWillBegin() {
        if addDimmingView ?? style.addDimmingView {
            containerView?.insertSubview(dimmingView, at: 0)
            containerView?.setFittingConstraints(childView: dimmingView, insets: .zero)
            dimmingView.layer.opacity = 0
            dimmingView.layer.animate(.fadeIn())
        }
        
        guard let presentedView else { return }
        containerView?.addSubview(presentedView)
        print("(DEBUG) presentedView.layout")
        presentedView.layoutIfNeeded()
        presentedView.frame = frameOfPresentedViewInContainerView
        presentedView.cornerRadius(16, at: .top)
    }
    
    
    public override func dismissalTransitionWillBegin() {
        guard addDimmingView ?? style.addDimmingView else { return }
        dimmingView.animate(.fadeOut(to: 0)) {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    @objc
    private func closeOnTap() {
        presentedViewController.dismiss(animated: true)
    }
    
    //MARK: Keyboard Adjustment
    var keyboardNotification: AnyPublisher<(Notification, Bool), Never> {
        let keyboardShow = NotificationCenter.default
            .publisher(for: UIApplication.keyboardWillShowNotification)
            .map { ($0, false) }
        
        let keyboardHide = NotificationCenter.default
            .publisher(for: UIApplication.keyboardWillHideNotification)
            .map { ($0, true) }
        
        return Publishers.Merge(keyboardShow, keyboardHide)
            .eraseToAnyPublisher()
    }
    
    func bindKeyboardAdjustment() {
        guard style.addKeyboardAdjustment else { return }
        keyboardNotification
            .withUnretained(self)
            .sinkReceive { $0.keyboardWillShow(notification: $1.0, hide: $1.1) }
            .store(in: &bag)
    }
    
    func keyboardWillShow(notification: Notification, hide: Bool = false) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                if hide {
                    self.presentedView?.transform = .identity
                } else {
                    self.presentedView?.transform = .init(translationX: 0, y: -keyboardHeight)
                    //self.presentedView?.transform = .init(translationX: 0, y: -keyboardHeight)
                }
            } completion: { isCompleted in
                guard isCompleted else { return }
                print("(DEBUG) self.presentedView.frame: ", self.presentedView?.frame ?? .zero)
            }
        }
    }
}

//MARK: - CirclePresentation UIViewControllerTransitioningDelegate

extension PresentationController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        self
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
}

//MARK: - CirclePresentation UIViewControllerAnimatedTransitioning

extension PresentationController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        style.transitionDuration }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let isPresented = presentedViewController.isBeingPresented
        let key: UITransitionContextViewControllerKey = isPresented ? .to : .from
        
        guard let vc = transitionContext.viewController(forKey: key) else { return }
        
        if !isPresented {
            if style.removeView {
                vc.view.removeChildViews()
                vc.view.addSubview(.solidColorView(frame: frameOfPresentedViewInContainerView, backgroundColor: .black))
            }
        }
        
        let presentedFrame = transitionContext.finalFrame(for: vc)
        let dismissedFrame = style.originalFrame(view: presentedViewController)
        
        let initialFrame = isPresented ? dismissedFrame : presentedFrame
        let finalFrame = isPresented ? presentedFrame : dismissedFrame
        
        let initialCornerRadius = isPresented ? style.cornerRadius : 0
        let finalCornerRadius = isPresented ? 0 : style.cornerRadius
        
        let initialScale = isPresented ? style.initScale : 1
        let finalScale = isPresented ? 1 : style.initScale
        
        let duration = transitionDuration(using: transitionContext)
        
        vc.view.frame = initialFrame
        if let icr = initialCornerRadius, style.cornerRadius != nil {
            vc.view.clippedCornerRadius = icr
        }
        vc.view.transform = .init(scaleX: initialScale, y: initialScale)
        
        if style.swipeToDismiss {
            vc.view.swipeGesture(direction: .down) { [weak vc] in
                vc?.dismiss(animated: true)
            }
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut])
        { [weak self] in
            guard let self else { return }
            vc.view.frame = finalFrame
            if let fcr = finalCornerRadius, self.style.cornerRadius != nil {
                vc.view.clippedCornerRadius = fcr
            }
            vc.view.transform = .init(scaleX: finalScale, y: finalScale)
        } completion: { isFinished in
            if !isPresented {
                vc.view.removeFromSuperview()
                self.onDismiss?()
            }
            transitionContext.completeTransition(isFinished)
        }
        
    }
    
    
}
