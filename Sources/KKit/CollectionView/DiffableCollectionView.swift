//
//  DiffableCollectionView.swift
//  
//
//  Created by Krishna Venkatramani on 04/08/2024.
//

import UIKit
import Combine

public class DiffableCollectionView: UICollectionView {
    
    private var dynamicDataSource: DiffableDataSource?
    
    var prefetchIndexPath: AnyPublisher<[IndexPath], Never>? {
        dynamicDataSource?.indexToPrefetch
    }
    
    var reachedEnd: AnyPublisher<Bool, Never>? {
        dynamicDataSource?.reachedEnd
    }
    
    func reloadWithDynamicSection(sections: [DiffableCollectionSection], completion: Callback? = nil) {
        
        if let source = self.dynamicDataSource {
            source.reloadSections(collection: self, sections, completion: completion)
            return
        }
        
        self.dynamicDataSource = DiffableDataSource(sections: sections)
        dynamicDataSource!.initializeDiffableDataSource(with: self, completion: completion)
    }
    
    func reloadItems(_ item: DiffableCollectionCellProvider, section: Int, index: Int, alsoReload: Bool = true) {
        guard let datasource = dynamicDataSource else  { return }
        
        datasource.reloadItems(item, section: section, index: index, alsoReload: alsoReload)
    }
    
}
