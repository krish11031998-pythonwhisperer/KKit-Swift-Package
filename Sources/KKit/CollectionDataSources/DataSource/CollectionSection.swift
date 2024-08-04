//
//  CollectionSection.swift
//
//
//  Created by Krishna Venkatramani on 04/08/2024.
//

import UIKit

public class CollectionSection {
    let cells: [DiffableCollectionCellProvider]
    
    public init(cells: [DiffableCollectionCellProvider]) {
        self.cells = cells
    }
    
    public func registerCell(collectionView: UICollectionView, cellRegistrationMap: inout Set<String>) {
        cells.forEach { cell in
            cell.register(cv: collectionView, registration: &cellRegistrationMap)
        }
    }
}


// MARK: - DataSource

public class DataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

    let sections: [CollectionSection]
    var cellRegistrations: Set<String> = .init()
    
    
    public init(sections: [CollectionSection]) {
        self.sections = sections
    }
    
    func registerCells(collectionView: UICollectionView) {
        sections.forEach { section in
            section.registerCell(collectionView: collectionView, cellRegistrationMap: &cellRegistrations)
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].cells.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        sections[indexPath.section].cells[indexPath.item].cell(cv: collectionView, indexPath: indexPath)
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sections[indexPath.section].cells[indexPath.item].didSelect(cv: collectionView, indexPath: indexPath)
    }
}
