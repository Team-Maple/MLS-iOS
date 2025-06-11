import UIKit

public class LayoutFactory {

    public init() {}

    public func getPageTabbarLayout() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .estimated(100), height: .absolute(40))
            .group(.horizontal, width: .estimated(100), height: .absolute(40))
            .buildSection()
            .orthogonalScrolling(.continuous)
            .interGroupSpacing(20)
            .contentInsets(.init(top: 0, leading: 16, bottom: 40, trailing: 16))
            .decorationItem(kind: PageTabbarDividerView.identifier, insets: .init(top: 39, leading: 0, bottom: 0, trailing: 0))
    }

    public func getItemTagListSection() -> CompositionalSectionBuilder {
        return CompositionalSectionBuilder()
            .item(width: .estimated(50), height: .absolute(34))
            .group(.horizontal, width: .fractionalWidth(1), height: .estimated(100))
            .interItemSpacing(.fixed(8))
            .buildSection()
            .header(height: 22)
            .interGroupSpacing(8)
            .contentInsets(.init(top: 12, leading: 16, bottom: 40, trailing: 16))
    }
}
