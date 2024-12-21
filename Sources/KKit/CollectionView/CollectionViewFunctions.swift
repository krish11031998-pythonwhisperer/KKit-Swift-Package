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
    
    private lazy var collectionView: DiffableCollectionView = {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = .init(width: .totalWidth, height: 54)
            layout.minimumLineSpacing = 10
            return layout
        }()
        let collectionView = DiffableCollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cells = (0...100).map { DiffableCollectionItem<TextView>("\($0)th Cell") }
        //let section = CollectionSection(cells: cells)
        let section = DiffableCollectionSection(0, cells: cells, sectionLayout: .singleColumnLayout(width: .fractionalWidth(1.0), height: .estimated(54)))
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        self.collectionView.reloadWithDynamicSection(sections: [section])
    }
}

@available(iOS 17.0, *)
#Preview("TestCollection", body: {
    TextCollection()
})
