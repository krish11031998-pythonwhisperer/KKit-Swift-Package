//
//  DiffableCollectionDecorationItem.swift
//  KKit
//
//  Created by Krishna Venkatramani on 21/12/2024.
//

import UIKit

public protocol CollectionDecorationViewProvider: Hashable, Equatable {
    func register(layout: UICollectionViewCompositionalLayout)
}

public extension CollectionDecorationViewProvider where Self : UICollectionReusableView {
    func register(layout: UICollectionViewCompositionalLayout) {
        layout.register(Self.self, forDecorationViewOfKind: Self.name)
    }
}
