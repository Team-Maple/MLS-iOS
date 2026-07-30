import UIKit

import MLSBookmarkFeature
import MLSBookmarkFeatureInterface
import MLSBookmarkFeatureTesting
import MLSCore
import MLSDictionaryFeatureInterface

final class MenuViewController: UITableViewController {

    private struct MenuItem {
        let title: String
        let subtitle: String
        let action: (UINavigationController) -> Void
    }

    private lazy var items: [MenuItem] = [
        MenuItem(
            title: "BookmarkMain",
            subtitle: "북마크 메인 (탭 + 페이지)"
        ) { nav in
            let factory = DIContainer.resolve(type: BookmarkMainFactory.self)
            let vc = factory.make(bottomInset: 0)
            let child = UINavigationController(rootViewController: vc)
            child.navigationBar.isHidden = true
            child.modalPresentationStyle = .fullScreen
            nav.present(child, animated: true)
        },
        MenuItem(
            title: "BookmarkList – 전체",
            subtitle: "전체 북마크 리스트"
        ) { nav in
            let factory = DIContainer.resolve(type: BookmarkListFactory.self)
            let vc = factory.make(type: .total, listType: .bookmark)
            nav.pushViewController(vc, animated: true)
        },
        MenuItem(
            title: "BookmarkList – 아이템",
            subtitle: "아이템 북마크 리스트 (필터 포함)"
        ) { nav in
            let factory = DIContainer.resolve(type: BookmarkListFactory.self)
            let vc = factory.make(type: .item, listType: .bookmark)
            nav.pushViewController(vc, animated: true)
        },
        MenuItem(
            title: "BookmarkList – 몬스터",
            subtitle: "몬스터 북마크 리스트 (필터 포함)"
        ) { nav in
            let factory = DIContainer.resolve(type: BookmarkListFactory.self)
            let vc = factory.make(type: .monster, listType: .bookmark)
            nav.pushViewController(vc, animated: true)
        },
        MenuItem(
            title: "CollectionList",
            subtitle: "컬렉션 목록"
        ) { nav in
            let factory = DIContainer.resolve(type: CollectionListFactory.self)
            let vc = factory.make()
            nav.pushViewController(vc, animated: true)
        },
        MenuItem(
            title: "CollectionDetail",
            subtitle: "컬렉션 상세 (빈 컬렉션)"
        ) { nav in
            let factory = DIContainer.resolve(type: CollectionDetailFactory.self)
            let stub = CollectionResponse(
                collectionId: 1,
                name: "내 컬렉션",
                createdAt: [2024, 1, 1],
                recentBookmarks: []
            )
            let vc = factory.make(collection: stub, onMoveToMain: nil)
            nav.pushViewController(vc, animated: true)
        },
        MenuItem(
            title: "BookmarkModal",
            subtitle: "컬렉션에 북마크 추가 모달"
        ) { nav in
            let factory = DIContainer.resolve(type: BookmarkModalFactory.self)
            let vc = factory.make(bookmarkIds: [1, 2, 3])
            vc.modalPresentationStyle = .pageSheet
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            nav.present(vc, animated: true)
        },
        MenuItem(
            title: "AddCollection",
            subtitle: "새 컬렉션 추가 모달"
        ) { nav in
            let factory = DIContainer.resolve(type: AddCollectionFactory.self)
            let vc = factory.make(collection: nil)
            nav.present(vc, animated: true)
        },
        MenuItem(
            title: "BookmarkOnBoarding",
            subtitle: "온보딩 화면"
        ) { nav in
            let factory = DIContainer.resolve(type: BookmarkOnBoardingFactory.self)
            let vc = factory.make()
            vc.modalPresentationStyle = .fullScreen
            nav.present(vc, animated: true)
        }
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmark Feature"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.secondaryText = item.subtitle
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let nav = navigationController else { return }
        items[indexPath.row].action(nav)
    }
}
