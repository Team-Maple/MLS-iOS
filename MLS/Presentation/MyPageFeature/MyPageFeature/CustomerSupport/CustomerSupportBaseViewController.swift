import UIKit

import BaseFeature
import DesignSystem
import DomainInterface
import MyPageFeatureInterface

import RxCocoa
import RxGesture
import RxSwift
/*
 **부모 뷰컨이 될 것 같음**
  */
class CustomerSupportBaseViewController: BaseViewController {
    // MARK: - Properties
    public var disposeBag = DisposeBag()

    /// 현재 보여지고 있는 뷰의 인덱스
    public var currentTabIndex: Int?
    public var urlStrings: [String] = []
    var onItemTapped: ((Int) -> Void)?

    private let policyFactory: PolicyFactory?

    // MARK: - Components
    public var mainView = CustomerSupportBaseView()
    public var type: CustomerSupportType

    public init(type: CustomerSupportType) {
        self.type = type
        self.policyFactory = nil
        super.init()
        mainView.titleLabel.attributedText = .makeStyledString(font: .sub_m_b, text: type.detailTitle)
    }

    public init(type: CustomerSupportType, policyFactory: PolicyFactory) {
        self.type = type
        mainView.titleLabel.attributedText = .makeStyledString(font: .sub_m_b, text: type.detailTitle)
        self.policyFactory = policyFactory
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isBottomTabbarHidden = true
        addViews()
        setupConstaraints()
        bindBackButton()
    }

    func createDetailItem(items: [AlarmResponse]) {
        for (index, item) in items.enumerated() {
            let view = mainView.createDetailItem(titleText: item.title, dateText: item.date.changeKoreanDate())
            view.tag = index
            urlStrings.append(item.link)

            view.isUserInteractionEnabled = true // 꼭 필요!

            view.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.handleItemTap(index: index)
                })
                .disposed(by: disposeBag)
        }
    }

    func createTermsDetailItem(items: [String]) {
        for (index, item) in items.enumerated() {
            let view = mainView.createDetailItem(titleText: item, dateText: nil)
            view.tag = index // 뷰에 index 태그 부여 (URL 매핑용)

            view.isUserInteractionEnabled = true

            view.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.handleItemTap(index: index)
                })
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - SetUp
extension CustomerSupportBaseViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstaraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension CustomerSupportBaseViewController {
    func handleItemTap(index: Int) {
        // 원하는 URL 열기 또는 네비게이션 처리
        switch type {
        case .announcement, .event, .patchNote:
            onItemTapped?(index)
            guard index < urlStrings.count else { return }
            let url = urlStrings[index]
            let webViewController = WebViewController(urlString: url)
            present(webViewController, animated: true)
        case .terms:
            switch index {
            case 0:
                guard let viewController = policyFactory?.make(type: .service) else { return }
                navigationController?.pushViewController(viewController, animated: true)
            case 1:
                guard let viewController = policyFactory?.make(type: .service) else { return }
                navigationController?.pushViewController(viewController, animated: true)
            default:
                break
            }
        }
    }

    func bindBackButton() {
        mainView.backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
