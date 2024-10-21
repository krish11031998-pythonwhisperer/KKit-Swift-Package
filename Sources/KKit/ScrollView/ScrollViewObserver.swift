//
//  ScrollViewObserver.swift
//  KKit
//
//  Created by Krishna Venkatramani on 21/10/2024.
//

import UIKit
import Combine


class ScrollViewObservers: NSObject, UICollectionViewDelegate {
    
    enum DragState {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#function)
        self.contentOffset = scrollView.contentOffset
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(#function)
        dragState = .willBegin
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(#function)
        dragState = .willEnd(velocity: velocity, contentOffset: targetContentOffset.pointee)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(#function)
        dragState = .didEnd
    }
    
}

extension UIScrollView {
    
    static var observerKey: UInt8 = 1
    
    var observer: ScrollViewObservers? {
        get { objc_getAssociatedObject(self, &Self.observerKey) as? ScrollViewObservers }
        set { objc_setAssociatedObject(self, &Self.observerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func setupObservers() {
        let observer = ScrollViewObservers()
        self.delegate = observer
        self.observer = observer
    }
    
}

