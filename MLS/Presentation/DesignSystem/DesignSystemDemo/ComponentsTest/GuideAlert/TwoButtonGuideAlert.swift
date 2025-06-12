import UIKit

import BaseFeature
import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

final class TwoButtonGuideAlert: UIViewController, ModalPresentable {
    // MARK: - Properties
    var disposeBag = DisposeBag()

    var modalHeight: CGFloat?

    private var mainView = GuideAlert(mainText: "북마크를 하려면 로그인이 필요해요.", ctaText: "로그인 하러 가기", cancelText: "취소")
}

// MARK: - Life Cycle
extension TwoButtonGuideAlert {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
    }
}

// MARK: - SetUp
private extension TwoButtonGuideAlert {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
