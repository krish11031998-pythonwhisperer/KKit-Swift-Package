//
//  UITestViewController.swift
//  KKit
//
//  Created by Krishna Venkatramani on 21/12/2024.
//

import UIKit
import SwiftUI
import KKit

private struct TestCellView: ConfigurableView {
    
    struct Model: Hashable {
        let sfSymbol: String
    }
    
    private let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Label {
                model.sfSymbol
                    .asText()
                    .font(.body)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } icon: {
                Image(systemName: model.sfSymbol)
            }
            
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.gray)
                .frame(width: 12, height: 12, alignment: .center)
        }
    }
    
    
    static func createContent(with model: Model) -> any UIContentConfiguration {
        UIHostingConfiguration {
            TestCellView(model: model)
        }
        .margins(.all, .zero)
    }
    
    static var viewName: String { "TestCellView" }
}

private class SectionHeader: UICollectionReusableView, ConfigurableCollectionSupplementaryView {
    
    struct Model: Hashable {
        let sectionTitle: String
    }
    
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        addSubview(label)
        label.fillSuperview(inset: .init(top: 10, left: 0, bottom: 0, right: 0))
        self.label = label
    }
    
    func configure(with model: Model) {
        model.sectionTitle.render(target: label)
    }
}


private class SectionDecoration: UICollectionReusableView, CollectionDecorationViewProvider {
    
    private var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradientLayer() {
        gradientLayer = .init()
        gradientLayer.colors = [UIColor.systemBlue.withAlphaComponent(0.15), UIColor.systemBlue.withAlphaComponent(0.05)].map(\.cgColor)
        gradientLayer.startPoint = .init(x: 0.5, y: 0)
        gradientLayer.endPoint = .init(x: 0.5, y: 1)
        
        layer.addSublayer(gradientLayer)
    }
}

class UITestViewController: UIViewController {
    
    private lazy var collectionView: DiffableCollectionView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCollection()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [unowned self] in
            self.reloadCollection()
        }
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    private func loadCollection() {
        collectionView.reloadWithDynamicSection(sections: [setupSectionOne()])
    }
    
    private func reloadCollection() {
        collectionView.reloadWithDynamicSection(sections: [setupSectionOne(), setupSectionTwo()])
    }
    
    private func setupSectionOne() -> DiffableCollectionSection {
        let symbols: [String] = ["square.and.arrow.up.on.square", "square.and.arrow.up.on.square.fill", "square.and.pencil.circle", "pencil.tip.crop.circle.badge.plus.fill", "sun.horizon.fill"]
        
        let models: [TestCellView.Model] = symbols.map { .init(sfSymbol: $0) }
        
        let cells = models.map { DiffableCollectionItem<TestCellView>($0) }
        
        let layout = NSCollectionLayoutSection.singleColumnLayout(width: .fractionalWidth(1.0), height: .estimated(54), insets: .section(.init(vertical: 10, horizontal: 20)))
            .addHeader()
        
        let header = CollectionSupplementaryView<SectionHeader>(.init(sectionTitle: "Test Section One"))
        
        let decorationItem = SectionDecoration()
        
        layout.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: SectionDecoration.name)]
        
        let section = DiffableCollectionSection(0, cells: cells, header: header, decorationItem: decorationItem, sectionLayout: layout)
        
        return section
    }
    
    private func setupSectionTwo() -> DiffableCollectionSection {
        let symbols: [String] = ["moonphase.first.quarter", "moonphase.waxing.gibbous", "moonphase.waning.gibbous", "moonphase.waxing.crescent.inverse", "moonphase.waxing.gibbous.inverse"]
        
        let models: [TestCellView.Model] = symbols.map { .init(sfSymbol: $0) }
        
        let cells = models.map { DiffableCollectionItem<TestCellView>($0) }
        
        let layout = NSCollectionLayoutSection.singleColumnLayout(width: .fractionalWidth(1.0), height: .estimated(54), insets: .section(.init(vertical: 10, horizontal: 20)))
            .addHeader()
        
        let header = CollectionSupplementaryView<SectionHeader>(.init(sectionTitle: "Test Section Two"))
        
        let decorationItem = SectionDecoration()
        
        layout.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: SectionDecoration.name)]
        
        let section = DiffableCollectionSection(1, cells: cells, header: header, decorationItem: decorationItem, sectionLayout: layout)
        
        return section
    }
}

@available(iOS 17.0, *)
#Preview("UITestViewController") {
    UITestViewController()
}
