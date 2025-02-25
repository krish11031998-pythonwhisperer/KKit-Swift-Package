//
//  GridLayout.swift
//  KKit
//
//  Created by Krishna Venkatramani on 01/02/2025.
//

import UIKit

public extension NSCollectionLayoutSection {
    static func gridLayout(itemSize: NSCollectionLayoutSize, groupSpacing: NSCollectionLayoutSpacing, interGroupSpacing: CGFloat) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension), subitems: [item])
        group.interItemSpacing = groupSpacing
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = .init(top: 16, leading: 24, bottom: 16, trailing: 24)
        return section
    }
    
}
