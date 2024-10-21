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
    private var dynamicDataSourceIsSet: PassthroughSubject<Void, Never> = .init()
    
    public var prefetchIndexPath: AnyPublisher<[IndexPath], Never>? {
        dynamicDataSource?.indexToPrefetch
    }
    
    public var reachedEnd: AnyPublisher<Bool, Never>? {
        dynamicDataSource?.reachedEnd
    }
    
    public func reloadWithDynamicSection(sections: [DiffableCollectionSection], completion: Callback? = nil) {
        
        if let source = self.dynamicDataSource {
            source.reloadSections(collection: self, sections, completion: completion)
            return
        }
        
        self.dynamicDataSource = DiffableDataSource(sections: sections)
        dynamicDataSource!.initializeDiffableDataSource(with: self, completion: completion)
        dynamicDataSourceIsSet.send(())
    }
    
    public func reloadItems(_ item: DiffableCollectionCellProvider, section: Int, index: Int, alsoReload: Bool = true) {
        guard let datasource = dynamicDataSource else  { return }
        
        datasource.reloadItems(item, section: section, index: index, alsoReload: alsoReload)
    }
    
    
    // MARK: - ScrollObservers
    
    public var diffableCollectionViewContentOffsetPublisher: AnyPublisher<CGPoint, Never> {
        dynamicDataSource?.contentOffsetPublisher ?? .empty(completeImmediately: true)
    }
    
    public var diffableCollectionViewDragStatePublisher: AnyPublisher<DiffableDataSource.DragState, Never> {
        dynamicDataSource?.dragStatePublisher ?? .empty(completeImmediately: true)
    }
    
    public var dynamicDataSourceIsSetPublisher: VoidPublisher {
        dynamicDataSourceIsSet.eraseToAnyPublisher()
    }
}
