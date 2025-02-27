//
//  UILabel+Extension.swift
//  KKit
//
//  Created by Krishna Venkatramani on 21/12/2024.
//

import UIKit
import Combine

public extension UILabel {
    
    @discardableResult
    func setAttributedTextToFitVertically(text: RenderableText, width: CGFloat, extraHeight: CGFloat = 1) -> CGFloat {
        guard let attributedText = text as? NSAttributedString else {
            text.render(target: self)
            return 0
        }
        
        let height = attributedText.height(withWidth: width) + extraHeight
        attributedText.render(target: self)
        setHeight(height: height)
        return height
    }
    
}
