//
//  ScrollViewObserver.swift
//  KKit
//
//  Created by Krishna Venkatramani on 21/10/2024.
//

import UIKit
import Combine


public class ScrollViewObserverManager: NSObject, UICollectionViewDelegate {
    
    public enum DragState {
        case willBegin
        case willEnd(velocity: CGPoint, contentOffset: CGPoint)
        case didEnd
        case unknown
    }
    
    @Published private var contentOffset: CGPoint = .zero
    @Published private var dragState: DragState = .unknown
    
    var contentOffsetPublisher: AnyPublisher<CGPoint, Never> {
        $contentOffset
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
    
    var dragStatePublisher: AnyPublisher<DragState, Never> {
        $dragState
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#function)
        self.contentOffset = scrollView.contentOffset
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(#function)
        dragState = .willBegin
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(#function)
        dragState = .willEnd(velocity: velocity, contentOffset: targetContentOffset.pointee)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(#function)
        dragState = .didEnd
    }
    
    
    // MARK: - Update
    
    func updateContentOffset(_ offset: CGPoint) {
        self.contentOffset = offset
    }
    
    func updateDragState(_ state: DragState) {
        self.dragState = state
    }
}

extension UIScrollView {
    
    internal static var observerKey: UInt8 = 1
    
    var observer: ScrollViewObserverManager? {
        get { objc_getAssociatedObject(self, &Self.observerKey) as? ScrollViewObserverManager }
        set { objc_setAssociatedObject(self, &Self.observerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func setupObservers() {
        let observer = ScrollViewObserverManager()
        self.delegate = observer
        self.observer = observer
    }
    
    public var contentOffsetPublisher: AnyPublisher<CGPoint, Never> {
        observer?.contentOffsetPublisher ?? .empty(completeImmediately: true)
    }
    
    public var dragPublisher: AnyPublisher<ScrollViewObserverManager.DragState, Never> {
        observer?.dragStatePublisher ?? .empty(completeImmediately: true)
    }
}

