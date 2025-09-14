import UIKit

import BaseFeature
import DomainInterface

import RxCocoa
import RxSwift
/*
**부모 뷰컨이 될 것 같음**
 */
class CustomerSupportBaseViewController: BaseViewController {
    // MARK: - Properties

    public var disposeBag = DisposeBag()

    // MARK: - Components
    public var mainView = CustomerSupportBaseView()
    public var type: CustomerSupportType
    
    /// 현재 보여지고 있는 뷰의 인덱스
    private var currentTabIndex: Int?
    public var urlStrings: [String] = []
    
    public init(type: CustomerSupportType) {
        self.type = type
        mainView.titleLabel.attributedText = .makeStyledString(font: .sub_m_b, text: type.detailTitle)
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
    }
    
    func createDetailItem(items: [(String, String)]) {
        for (index, item) in items.enumerated() {
            let view = mainView.createDetailItem(titleText: item.0, dateText: item.1)
            view.tag = index
            if index == 0 {
                urlStrings.append("https://www.naver.com")
            } else {
                urlStrings.append("https://www.naver.com")
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemTapped))
            view.addGestureRecognizer(tapGesture)
            view.isUserInteractionEnabled = true // 꼭 필요!
        }
    }
    
    func createTermsDetailItem(items: [String]) {
        for (index, item) in items.enumerated() {
            let view = mainView.createDetailItem(titleText: item, dateText: nil)
            view.tag = index // 뷰에 index 태그 부여 (URL 매핑용)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(itemTapped))
            view.addGestureRecognizer(gesture)
            view.isUserInteractionEnabled = true
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
    
    // 이벤트 뷰가 아닐 경우 메뉴 태ㅐ그 필요없음 -> 제약사항 변경 되어야 함
    func changeeSetupConstraints() {
        mainView.scrollView.snp.remakeConstraints { make in
            make.top.equalTo(mainView.headerView.snp.bottom).offset(CustomerSupportBaseView.Constant.topMargin)
            make.width.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
extension CustomerSupportBaseViewController {

    @objc public func itemTapped(_ sender: UITapGestureRecognizer) {
        switch type {
        case .announcement, .event, .patchNote:
            print("not terms")
            guard let tappedView = sender.view else { return }
            let index = tappedView.tag
            let url = urlStrings[index]
            let webViewController = WebViewController(urlString: url)
            navigationController?.pushViewController(webViewController, animated: true)
        case .terms:
            print("terms")
            let viewController = TermsDetailViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }
   
    }
}
