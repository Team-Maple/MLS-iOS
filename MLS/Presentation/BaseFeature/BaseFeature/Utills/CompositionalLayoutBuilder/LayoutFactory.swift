import UIKit

public class LayoutFactory {

    public init() {}

    static public func getPageTabbarLayout() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .estimated(100), height: .absolute(40))
            .group(.horizontal, width: .estimated(100), height: .absolute(40))
            .buildSection()
            .orthogonalScrolling(.continuous)
            .interGroupSpacing(20)
            .contentInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            .decorationItem(kind: Neutral300DividerView.identifier, insets: .init(top: 39, leading: 0, bottom: 0, trailing: 0))
    }

    static public func getItemTagListSection() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .estimated(120), height: .absolute(34))
            .group(.horizontal, width: .fractionalWidth(1), height: .absolute(34))
            .interItemSpacing(.fixed(8))
            .buildSection()
            .header(height: 22)
            .interGroupSpacing(8)
            .contentInsets(.init(top: 12, leading: 16, bottom: 32, trailing: 16))
    }
    
    static public func getLevelRangeSection() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .fractionalWidth(1), height: .estimated(100))
            .group(.horizontal, width: .fractionalWidth(1), height: .estimated(100))
            .buildSection()
            .header(height: 22)
            .contentInsets(.init(top: 12, leading: 16, bottom: 32, trailing: 16))
    }
}
