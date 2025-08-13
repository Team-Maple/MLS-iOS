import UIKit

public final class CompositionalSectionBuilder {
    private var item: NSCollectionLayoutItem?
    private var group: NSCollectionLayoutGroup?
    private var section: NSCollectionLayoutSection?

    public enum Direction {
        case horizontal, vertical
    }

    public init(item: NSCollectionLayoutItem? = nil, group: NSCollectionLayoutGroup? = nil, section: NSCollectionLayoutSection? = nil) {
        self.item = item
        self.group = group
        self.section = section
    }

    @discardableResult
    public func item(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension) -> Self {
        let size = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        item = NSCollectionLayoutItem(layoutSize: size)
        return self
    }

    @discardableResult
    public func group(_ direction: Direction, width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, count: Int? = nil) -> Self {
        guard let item = item else { return self }
        let size = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        switch direction {
        case .horizontal:
            if let count = count {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: count)
            } else {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
            }
        case .vertical:
            if let count = count {
                group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: item, count: count)
            } else {
                group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
            }
        }
        return self
    }

    @discardableResult
    public func customGroup(group: (NSCollectionLayoutItem) -> NSCollectionLayoutGroup) -> Self {
        guard let item = item else { return self }
        self.group = group(item)
        return self
    }

    @discardableResult
    public func buildSection() -> Self {
        guard let group = group else { return self }
        section = NSCollectionLayoutSection(group: group)
        return self
    }

    @discardableResult
    public func visibleItemsInvalidationHandler(
        handler: @escaping ([any NSCollectionLayoutVisibleItem], CGPoint, any NSCollectionLayoutEnvironment) -> Void
    ) -> Self {
        section?.visibleItemsInvalidationHandler = { visibleItems, scrollOffset, environment in
            handler(visibleItems, scrollOffset, environment)
        }
        return self
    }

    @discardableResult
    public func orthogonalScrolling(_ behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> Self {
        section?.orthogonalScrollingBehavior = behavior
        return self
    }

    @discardableResult
    public func contentInsets(_ insets: NSDirectionalEdgeInsets) -> Self {
        section?.contentInsets = insets
        return self
    }

    @discardableResult
    public func header(height: CGFloat, isSticky: Bool = false) -> Self {
        guard let section = section else { return self }

        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        header.pinToVisibleBounds = isSticky
        section.boundarySupplementaryItems = [header]
        return self
    }

    public func build() -> NSCollectionLayoutSection? {
        return section
    }

    @discardableResult
    public func interGroupSpacing(_ spacing: CGFloat) -> Self {
        section?.interGroupSpacing = spacing
        return self
    }

    @discardableResult
    public func interItemSpacing(_ spacing: NSCollectionLayoutSpacing) -> Self {
        group?.interItemSpacing = spacing
        return self
    }

    @discardableResult
    public func footer(height: CGFloat) -> Self {
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(height)
            ),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        section?.boundarySupplementaryItems.append(footer)
        return self
    }

    @discardableResult
    public func supplementaryItem(
        kind: String,
        height: CGFloat,
        alignment: NSRectAlignment
    ) -> Self {
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(height)
            ),
            elementKind: kind,
            alignment: alignment
        )
        section?.boundarySupplementaryItems.append(header)
        return self
    }

    @discardableResult
    public func decorationItem(
        kind: String,
        insets: NSDirectionalEdgeInsets = .zero
    ) -> Self {
        let decoration = NSCollectionLayoutDecorationItem.background(elementKind: kind)
        decoration.contentInsets = insets
        section?.decorationItems.append(decoration)
        return self
    }

    @discardableResult
    public func nestedGroup(
        outerDirection: Direction,
        outerWidth: NSCollectionLayoutDimension,
        outerHeight: NSCollectionLayoutDimension,
        innerDirection: Direction,
        innerWidth: NSCollectionLayoutDimension,
        innerHeight: NSCollectionLayoutDimension,
        innerCount: Int? = nil,
        innerSpacing: CGFloat
    ) -> Self {
        guard let item = item else { return self }

        // 내부 그룹
        let innerSize = NSCollectionLayoutSize(widthDimension: innerWidth, heightDimension: innerHeight)
        let innerGroup: NSCollectionLayoutGroup
        switch innerDirection {
        case .horizontal:
            if let count = innerCount {
                innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: innerSize, subitem: item, count: count)
            } else {
                innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: innerSize, subitems: [item])
            }
            innerGroup.interItemSpacing = .fixed(innerSpacing)
        case .vertical:
            if let count = innerCount {
                innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerSize, subitem: item, count: count)
            } else {
                innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerSize, subitems: [item])
            }
            innerGroup.interItemSpacing = .fixed(innerSpacing)
        }

        // 외부 그룹
        let outerSize = NSCollectionLayoutSize(widthDimension: outerWidth, heightDimension: outerHeight)
        switch outerDirection {
        case .horizontal:
            group = NSCollectionLayoutGroup.horizontal(layoutSize: outerSize, subitems: [innerGroup])
        case .vertical:
            group = NSCollectionLayoutGroup.vertical(layoutSize: outerSize, subitems: [innerGroup])
        }

        return self
    }
}
