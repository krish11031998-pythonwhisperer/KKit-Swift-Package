//
//  CollectionViewFunctions.swift
//  KKit
//
//  Created by Krishna Venkatramani on 29/12/2023.
//

import Foundation
import SwiftUI
import UIKit
import Combine

extension UICollectionView {
    
    func dequeueCell<C: ConfigurableCollectionCell>(name: String = C.cellName, indexPath: IndexPath) -> C? {
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? C else {
            register(C.self, forCellWithReuseIdentifier: C.name)
            return dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? C ?? C()
        }
        
        return cell
    }
}

// MARK: - UICollectionView+DiffableDataSource

public extension UICollectionView {
    
//    static var dynamicDataSourceObject: [UICollectionView:DiffableDataSource] = [:]
//    
//    var dynamicDataSource: DiffableDataSource? {
//        get { Self.dynamicDataSourceObject[self] }
//        set { Self.dynamicDataSourceObject[self] = newValue }
//    }
    
    private static var propertyKey: UInt8 = 1
    
    var dynamicDataSource: DiffableDataSource? {
        get { objc_getAssociatedObject(DiffableDataSource.self, &Self.propertyKey) as? DiffableDataSource }
        set { objc_setAssociatedObject(DiffableDataSource.self, &Self.propertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
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


// MARK: - UICollectionView+DataSource

public extension UICollectionView {
    
    private static var dataSourceKey: UInt8 = 1
    
    private var dataSourceReference: DataSource? {
        get { objc_getAssociatedObject(DataSource.self, &Self.dataSourceKey) as? DataSource }
        set { objc_setAssociatedObject(DataSource.self, &Self.dataSourceKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func reloadData(section: [CollectionSection]) {
        let dataSource = DataSource(sections: section)
        dataSource.registerCells(collectionView: self)
        self.dataSource = dataSource
        self.delegate = dataSource
        self.dataSourceReference = dataSource
        self.reloadData()
    }
}


// MARK: - Strictly for Testing only Remove this later

struct TextView: ConfigurableView {
    
    typealias Model = String
    
    private let text: Model
    
    init(text: Model) {
        self.text = text
    }
    
    var body: some View {
        Text(self.text)
            .font(.body)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    static func createContent(with model: String) -> any UIContentConfiguration {
        UIHostingConfiguration {
            TextView(text: model)
        }
    }
    
    static var viewName: String { "TextView" }
}


private class TextCollection: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = .init(width: .totalWidth, height: 54)
            layout.minimumLineSpacing = 10
            return layout
        }()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cells = (0...100).map { DiffableCollectionItem<TextView>("\($0)th Cell") }
        let section = CollectionSection(cells: cells)
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        self.collectionView.reloadData(section: [section])
    }
}

@available(iOS 17.0, *)
#Preview("TestCollection", body: {
    TextCollection()
})
