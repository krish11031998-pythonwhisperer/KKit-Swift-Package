//
//  File.swift
//  
//
//  Created by Krishna Venkatramani on 23/04/2024.
//

import UIKit

public extension UIViewController {
    
    var preferredContentHeight: CGFloat {
        guard preferredContentSize.height == 0 else { return preferredContentSize.height }
        return calculateHeight()
    }
    
    func calculateHeight() -> CGFloat {
        let topInset = self.navBarHeight
        
        if let scrollView = view as? UIScrollView {
            return scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom + topInset
        }
            
        var height = view.compressedSize.height + topInset
            
        //MARK: - ScrollView
        let scrollViews = view.subviews.compactMap { $0 as? UIScrollView }
        
        height += scrollViews.reduce(CGFloat(0), { result, scrollView in
            if scrollView.intrinsicContentSize.height <= 0 {
                return result + scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom
            } else {
                return result
            }
        })
        
        
    
        return height
    }
    
}
