//
//  DiffableCollectionSection.swift
//  KKit
//
//  Created by Krishna Venkatramani on 29/12/2023.
//

import UIKit
import SwiftUI

// MARK: - DynamicCollectionDiffableDataSource

public typealias DiffableCollectionDataSource = UICollectionViewDiffableDataSource<Int, DiffableCollectionCellItem>

public typealias CollectionDiffableSnapshot = NSDiffableDataSourceSnapshot<Int, DiffableCollectionCellItem>

// MARK: - DynamicCollectionCellProvider

public protocol DiffableCollectionCellProviderType: Hashable, AnyObject {
    func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func didSelect(cv: UICollectionView, indexPath: IndexPath)
    var asCellItem: DiffableCollectionCellItem { get }
    func register(cv: UICollectionView, registration: inout Set<String>)
}

public typealias DiffableCollectionCellProvider = any DiffableCollectionCellProviderType

// MARK: - DynamicCollectionCellItem

public enum DiffableCollectionCellItem: Hashable {
    case view(DiffableCollectionCellProvider)
    case item(DiffableCollectionCellProvider)
    
    public static func == (lhs: DiffableCollectionCellItem, rhs: DiffableCollectionCellItem) -> Bool {
        switch(lhs, rhs) {
        case (.view(let providerOne), .view(let providerTwo)):
            return providerOne.hashValue == providerTwo.hashValue
        case (.item(let pOne), .item(let pTwo)):
            return pOne.hashValue == pTwo.hashValue
        default:
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .view(let provider):
            hasher.combine(provider)
        case .item(let provider):
            hasher.combine(provider)
        }
    }
}


// MARK: - DiffableCollectionCell

public class DiffableCollectionCell<Cell: ConfigurableCollectionCell>: DiffableCollectionCellProviderType {
    
    var model: Cell.Model
    
    public init(_ model: Cell.Model) {
        self.model = model
    }
    
    public func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: Cell = cv.dequeueCell(indexPath: indexPath) else {
            let cell = UICollectionViewCell()
            let cellView = Cell()
            cellView.configure(with: model)
            cell.contentView.addSubview(cellView)
            cellView.fillSuperview()
            return cell
        }
        cell.configure(with: model)
        return cell
    }
    
    public func didSelect(cv: UICollectionView, indexPath: IndexPath) {
        guard let action = (model as? ActionProvider)?.action else { return }
        action()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(Cell.cellName)
        hasher.combine(model)
    }
    
    public static func == (lhs: DiffableCollectionCell<Cell>, rhs: DiffableCollectionCell<Cell>) -> Bool {
        lhs.model == rhs.model
    }
    
    public var asCellItem: DiffableCollectionCellItem { .view(self) }
    
    public func register(cv: UICollectionView, registration: inout Set<String>) {
        guard (registration.first(where: { $0 == Cell.cellName }) == nil) else { return }
        cv.register(Cell.self, forCellWithReuseIdentifier: Cell.cellName)
        registration.insert(Cell.cellName)
    }
}


// MARK: - DiffableCollectionCellView

public class DiffableCollectionCellView<View: ConfigurableUIView>: DiffableCollectionCellProviderType {
    
    private let model: View.Model
    
    public init(model: View.Model) {
        self.model = model
    }
    
    public func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: View.cellName, for: indexPath)
        
        if let cellView = cell.contentView.subviews.first(where: { ($0 as? View) != nil }) as? View {
            cellView.configure(with: model)
            return cell
        }
        
        let cellView = View()
        cellView.configure(with: model)
        cell.contentView.addSubview(cellView)
        cellView.fillSuperview()
        return cell
    }
    
    public func didSelect(cv: UICollectionView, indexPath: IndexPath) {
        guard let action = (model as? ActionProvider)?.action else { return }
        action()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(View.cellName)
        hasher.combine(model)
    }
    
    public static func == (lhs: DiffableCollectionCellView<View>, rhs: DiffableCollectionCellView<View>) -> Bool {
        lhs.model == rhs.model
    }
    
    public var asCellItem: DiffableCollectionCellItem { .view(self) }
    
    public func register(cv: UICollectionView, registration: inout Set<String>) {
        guard (registration.first(where: { $0 == View.cellName }) == nil) else { return }
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: View.cellName)
        registration.insert(View.cellName)
    }
}

// MARK: - DiffableCollectionItem

public class DiffableCollectionItem<View: ConfigurableView>: DiffableCollectionCellProviderType {
    var model: View.Model
    
    public init(_ model: View.Model) {
        self.model = model
    }
    
    public func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        cell.configurationUpdateHandler = { [unowned self] cell, cellState in
            cell.contentConfiguration = UIHostingConfiguration {
                View(model: self.model)
                    .environment(\.cellState, cellState)
            }
            .margins(.all, .zero)
        }
        return cell
    }
    
    public func didSelect(cv: UICollectionView, indexPath: IndexPath) {
        guard let action = (model as? ActionProvider)?.action else { return }
        action()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(View.viewName)
        hasher.combine(model)
    }
    
    public static func == (lhs: DiffableCollectionItem<View>, rhs: DiffableCollectionItem<View>) -> Bool {
        lhs.model == rhs.model
    }
    
    public var asCellItem: DiffableCollectionCellItem { .item(self) }
    
    private var cellName: String { "\(View.viewName)Cell" }
    
    public func register(cv: UICollectionView, registration: inout Set<String>) {
        guard (registration.first(where: { $0 == cellName }) == nil) else { return }
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellName)
        registration.insert(cellName)
    }
}
