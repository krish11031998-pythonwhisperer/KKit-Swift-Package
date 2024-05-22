//
//  SingleRowLayout.swift
//  KKit
//
//  Created by Krishna Venkatramani on 01/01/2024.
//

import UIKit

public extension NSCollectionLayoutSection {
    
    static func singleRowLayout(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, insets: Insets = .all(.init(by: 10)), spacing: CGFloat = 8) -> NSCollectionLayoutSection {
        let size: NSCollectionLayoutSize = .init(widthDimension: width, heightDimension: height)
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        
        group.edgeSpacing = .init(leading: .fixed(insets.groupInsets.leading), top: .fixed(insets.groupInsets.top), trailing: .fixed(insets.groupInsets.trailing), bottom: .fixed(insets.groupInsets.bottom))
        
        let layoutSection = NSCollectionLayoutSection(group: group)
        
        layoutSection.contentInsets = insets.sectionInsets
        
        layoutSection.interGroupSpacing = spacing
        
        layoutSection.orthogonalScrollingBehavior = .continuous
        
        return layoutSection
    }
    
}
