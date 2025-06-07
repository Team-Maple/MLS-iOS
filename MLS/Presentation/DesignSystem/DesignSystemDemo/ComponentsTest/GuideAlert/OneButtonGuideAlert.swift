import UIKit

import BaseFeature
import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

final class OneButtonGuideAlert: UIViewController, ModalPresentable {
    // MARK: - Properties
    var disposeBag = DisposeBag()

    var modalHeight: CGFloat?
    var modalStyle: ModalStyle = .modal

    private var mainView = GuideAlert(mainText: "북마크를 하려면 로그인이 필요해요.", ctaText: "로그인 하러 가기", cancelText: nil)
}

// MARK: - Life Cycle
extension OneButtonGuideAlert {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
    }
}

// MARK: - SetUp
private extension OneButtonGuideAlert {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
