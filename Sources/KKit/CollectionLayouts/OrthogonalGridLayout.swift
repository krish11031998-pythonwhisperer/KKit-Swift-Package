//
//  OrthogonalGridLayout.swift
//  KKit
//
//  Created by Krishna Venkatramani on 07/09/2026.
//

import UIKit

public extension NSCollectionLayoutSection {
    static func orthogonalGrid(gridWidth width: NSCollectionLayoutDimension, gridHeight height: NSCollectionLayoutDimension, spacing: CGFloat, contentInsets: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
        let group = NSCollectionLayoutGroup.custom(layoutSize: .init(widthDimension: width, heightDimension: height)) { env in
            let containerWidth = (env.container.effectiveContentSize.width - spacing).half
            let contentHeight = (env.container.effectiveContentSize.height - spacing).half
            let size = CGSize(width: containerWidth, height: contentHeight)
            
            var maxY: CGFloat = .zero
            var maxX: CGFloat = .zero
            var frames: [NSCollectionLayoutGroupCustomItem] = []
            
            for i in 0..<4 {
                frames.append(.init(frame: .init(origin: .init(x: maxX, y: maxY), size: size)))
                if i%2 == 0 {
                    maxX += containerWidth + spacing
                } else {
                    maxX = 0
                    maxY += contentHeight + spacing
                }
            }
            
            return frames
        }
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = contentInsets
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
}
