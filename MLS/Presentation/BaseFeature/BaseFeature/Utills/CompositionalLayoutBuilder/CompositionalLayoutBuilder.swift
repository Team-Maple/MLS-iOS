import UIKit

public final class CompositionalLayoutBuilder {
    private var sections: [NSCollectionLayoutSection] = []

    public init() {}

    @discardableResult
    public func section(_ build: (CompositionalSectionBuilder) -> CompositionalSectionBuilder) -> Self {
        let builder = CompositionalSectionBuilder()
        if let section = build(builder).build() {
            sections.append(section)
        }
        return self
    }

    public func build() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { index, _ in
            guard index < self.sections.count else { return nil }
            return self.sections[index]
        }
    }

    public func setSections(_ sections: [NSCollectionLayoutSection]) -> Self {
        self.sections = sections
        return self
    }
}
