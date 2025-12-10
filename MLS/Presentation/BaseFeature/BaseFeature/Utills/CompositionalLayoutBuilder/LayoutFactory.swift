import UIKit

public class LayoutFactory {
    public init() {}

    public static func getPageTabbarLayout(underLineController: TabBarUnderlineController? = nil) -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .estimated(100), height: .absolute(40))
            .group(.horizontal, width: .estimated(100), height: .absolute(40))
            .buildSection()
            .orthogonalScrolling(.continuous)
            .interGroupSpacing(28)
            .contentInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            .visibleItemsInvalidationHandler { _, offset, _ in
                underLineController?.updateScrollOffset(offset)
            }
    }

    public static func getItemTagListSection(width: CGFloat = 50) -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .estimated(width), height: .absolute(34))
            .group(.horizontal, width: .fractionalWidth(1), height: .absolute(34))
            .interItemSpacing(.fixed(8))
            .buildSection()
            .header(height: 22)
            .interGroupSpacing(8)
            .contentInsets(.init(top: 12, leading: 16, bottom: 32, trailing: 16))
    }

    public static func getLevelRangeSection() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1), height: .estimated(100))
            .group(.horizontal, width: .fractionalWidth(1), height: .estimated(100))
            .buildSection()
            .header(height: 22)
            .contentInsets(.init(top: 12, leading: 16, bottom: 32, trailing: 16))
    }

    public func getDictionaryListLayout(isFilterHidden: Bool = true) -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1.0), height: .absolute(104))
            .group(.horizontal, width: .fractionalWidth(1.0), height: .absolute(104))
            .buildSection()
            .interGroupSpacing(10)
            .contentInsets(.init(top: isFilterHidden ? 20 : 0, leading: 16, bottom: 0, trailing: 16))
    }

    public func getTagChipLayout() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .estimated(70), height: .estimated(32))
            .group(.horizontal, width: .estimated(70), height: .estimated(32))
            .buildSection()
            .header(height: 44)
            .orthogonalScrolling(.continuous)
            .interGroupSpacing(8)
            .contentInsets(.init(top: 24, leading: 16, bottom: 24, trailing: 16))
    }

    public func getDecorationSection() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1.0), height: .absolute(1))
            .group(.vertical, width: .fractionalWidth(1.0), height: .absolute(10))
            .buildSection()
            .decorationItem(kind: SearchDividerView.identifier)
            .contentInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
    }

    public func getPopularResultLayout() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1.0), height: .estimated(40))
            .group(.horizontal, width: .fractionalWidth(1.0), height: .estimated(40), count: 2)
            .buildSection()
            .header(height: 44)
            .contentInsets(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
    }

    public static func getNotificationLayout() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1.0), height: .estimated(86))
            .group(.vertical, width: .fractionalWidth(1.0), height: .estimated(86))
            .buildSection()
            .interGroupSpacing(8)
            .contentInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
    }

    public func getCollectionModalLayout() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1.0), height: .absolute(72))
            .group(.vertical, width: .fractionalWidth(1.0), height: .absolute(72))
            .buildSection()
            .interGroupSpacing(1)
    }

    public func getCollectionListLayout() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1.0), height: .absolute(96))
            .group(.vertical, width: .fractionalWidth(1.0), height: .absolute(96))
            .buildSection()
            .interGroupSpacing(10)
            .contentInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
    }

    public func getCollectionListEditLayout() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1.0), height: .absolute(104))
            .group(.vertical, width: .fractionalWidth(1.0), height: .absolute(104))
            .buildSection()
            .interGroupSpacing(10)
            .contentInsets(.init(top: 20, leading: 16, bottom: 20, trailing: 16))
    }

    // 이 아래는 정리
    public func getMyPageMainLayout() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1.0), height: .estimated(200))
            .group(.vertical, width: .fractionalWidth(1.0), height: .estimated(200))
            .buildSection()
    }

    public func getMyPageSettingLayout() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1.0), height: .absolute(50))
            .group(.vertical, width: .fractionalWidth(1.0), height: .estimated(100))
            .buildSection()
            .decorationItem(kind: SettingBackgroundView.identifier)
            .contentInsets(.init(top: 20 + 10, leading: 16 + 10, bottom: 10, trailing: 16 + 10))
    }

    public func getMyPageSupportLayout() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1.0), height: .absolute(50))
            .group(.vertical, width: .fractionalWidth(1.0), height: .estimated(100))
            .buildSection()
            .decorationItem(kind: SupportBackgroundView.identifier)
            .contentInsets(.init(top: 16 + 10, leading: 16 + 10, bottom: 20 + 10, trailing: 16 + 10))
    }

    public func getSelectImageLayout() -> CompositionalSectionBuilder {
        let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0/3.0),
                heightDimension: .fractionalWidth(1.0/3.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0/3.0)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])
            group.interItemSpacing = .fixed(16)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 16)

            return CompositionalSectionBuilder(section: section)
    }
}
