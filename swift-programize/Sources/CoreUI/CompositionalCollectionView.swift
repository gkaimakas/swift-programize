//
//  CompositionalCollectionView.swift
//  swift-programize
//
//  Created by George Kaimakas on 18/10/24.
//




import UIKit

open class CompositionalCollectionView<SectionID: Hashable & Sendable, ItemID: Hashable & Sendable>: UIView {
    private(set)
    public var collectionView: CollectionView!
    
    private(set)
    public var layout: UICollectionViewCompositionalLayout!
    
    private(set)
    public var dataSource: DiffableDataSource<SectionID, ItemID>!
    
    public init(
        frame: CGRect,
        configuration: UICollectionViewCompositionalLayoutConfiguration = .init()
    ) {
        
        super.init(frame: frame)
        
        layout = .init(
            sectionProvider: _sectionProvider,
            configuration: configuration
        )
        
        collectionView = .init(
            frame: frame,
            collectionViewLayout: layout
        )
        
        dataSource = .init(
            collectionView: collectionView,
            cellProvider: _cellProvider
        )
        
        dataSource.supplementaryViewProvider = _supplementaryViewProvider
        dataSource.prefetchItems = prefetchItems
        dataSource.cancelPrefetchingItems = cancelPrefetch
        
        collectionView.prefetchDataSource = dataSource
        
        buildLayout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildLayout() {
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func _sectionProvider(
        index: Int,
        environment: any NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection? {
        guard let section = dataSource.sectionIdentifier(for: index) else {
            return nil
        }
        
        return sectionLayout(
            for: section,
            context: .init(index: index, environment: environment)
        )
    }
    
    private func _cellProvider(
        _ collectionView: UICollectionView,
        indexPath: IndexPath,
        item: ItemID
    ) -> UICollectionViewCell? {
        return cell(
            for: item,
            context: .init(collectionView: collectionView, indexPath: indexPath)
        )
    }
    
    private func _supplementaryViewProvider(
        _ collectionView: UICollectionView,
        _ elementKind: String,
        _ indexPath: IndexPath
    ) -> UICollectionReusableView? {
        guard let section = dataSource.sectionIdentifier(for: indexPath.section) else { return nil }
        return supplementaryView(
            for: section,
            context: .init(
                collectionView: collectionView,
                elementKind: elementKind,
                indexPath: indexPath
            )
        )
    }
    
    open func sectionLayout(
        for section: SectionID,
        context: SectionContext
    ) -> NSCollectionLayoutSection {
        fatalError()
    }
    
    open func cell(
        for item: ItemID,
        context: ItemContext
    ) -> UICollectionViewCell {
        fatalError()
    }
    
    open func supplementaryView(
        for section: SectionID,
        context: SupplementaryViewContext
    ) -> UICollectionReusableView? {
        fatalError()
    }
    
    open func prefetchItems(
        _ collectionView: UICollectionView,
        items: [ItemID]
    ) {
    }
    
    open func cancelPrefetch(
        _ collectionView: UICollectionView,
        items: [ItemID]
    ) {
    }
    
    open func willDisplay(
        cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath,
        item: ItemID
    ) {
        
    }
}

public extension CompositionalCollectionView {
    struct SectionContext {
        public var index: Int
        public var environment: any NSCollectionLayoutEnvironment
        
        fileprivate init(
            index: Int,
            environment: any NSCollectionLayoutEnvironment
        ) {
            self.index = index
            self.environment = environment
        }
    }
    
    struct ItemContext {
        public var collectionView: UICollectionView
        public var indexPath: IndexPath
        
        fileprivate init(
            collectionView: UICollectionView,
            indexPath: IndexPath
        ) {
            self.collectionView = collectionView
            self.indexPath = indexPath
        }
        
        @MainActor
        public func dequeueCell<Cell, Item>(
            using registration: UICollectionView.CellRegistration<Cell, Item>,
            item: Item?
        ) -> Cell where Cell : UICollectionViewCell {
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        }
    }
    
    struct SupplementaryViewContext {
        public var collectionView: UICollectionView
        public var elementKind: String
        public var indexPath: IndexPath
        
        fileprivate init(
            collectionView: UICollectionView,
            elementKind: String,
            indexPath: IndexPath
        ) {
            self.collectionView = collectionView
            self.elementKind = elementKind
            self.indexPath = indexPath
        }
        
        @MainActor
        public func dequeueSupplementary<Supplementary>(
            using registration: UICollectionView.SupplementaryRegistration<Supplementary>
        ) -> Supplementary where Supplementary : UICollectionReusableView {
            collectionView.dequeueConfiguredReusableSupplementary(
                using: registration,
                for: indexPath
            )
        }
    }
}

public class CollectionView: UICollectionView {}

public class DiffableDataSource<SectionID: Hashable & Sendable, ItemID: Hashable & Sendable>: UICollectionViewDiffableDataSource<SectionID, ItemID>, UICollectionViewDataSourcePrefetching {
    var prefetchItems: ((UICollectionView, [ItemID]) -> Void)?
    var cancelPrefetchingItems: ((UICollectionView, [ItemID]) -> Void)?
    
    public func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
        let items = indexPaths.map { self.itemIdentifier(for: $0) }.compactMap { $0 }
        prefetchItems?(collectionView, items)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cancelPrefetchingForItemsAt indexPaths: [IndexPath]
    ) {
        let items = indexPaths.map { self.itemIdentifier(for: $0) }.compactMap { $0 }
        cancelPrefetchingItems?(collectionView, items)
    }
}
