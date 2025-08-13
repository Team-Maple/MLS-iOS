import UIKit

import DesignSystem
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

/// compositionalLayout을 사용하는 도감 상세 - 상세 정보에서 Header로 사용하기 위한 View
/// 상세 정보 / 출현 맵 등의 탭을 담은 stackView
final class DictionaryDetailHeaderView: UICollectionReusableView, View {
    // MARK: - Type
    enum Constant {
        static let tabHeight: CGFloat = 40
        static let horizontalInset: CGFloat = 16
        static let spacing: CGFloat = 20
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Components
    /// 탭이 늘어나거나 화면이 작아질 수 있으므로 scrollView 적용
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
        return scrollView
    }()
    
    private let tabStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constant.spacing
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: Constant.horizontalInset, bottom: 0, right: Constant.horizontalInset)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral300
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - SetUp
private extension DictionaryDetailHeaderView {
    func addViews() {
        addSubview(scrollView)
        addSubview(underLine)
        scrollView.addSubview(tabStackView)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constant.tabHeight)
        }
        
        tabStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        underLine.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
    
    func selectTab(index: Int) {
        guard index < tabStackView.arrangedSubviews.count else { return }

        tabStackView.arrangedSubviews.enumerated().forEach { idx, view in
            guard let button = view as? UIButton else { return }
            // attributedText를 적용하는게 정확하지만 text 속성을 관리해야해서 일반 text에 폰트와 색상만 적용
            button.titleLabel?.font = .korFont(style: .regular, size: 16)
            button.setTitleColor(.neutral600, for: .normal)
            button.subviews.filter { $0.tag == 1 }.forEach { $0.removeFromSuperview() }
        }

        // [UIButton]을 가지고있는게 아니라 stackView에서 찾아서 변경
        if let currentButton = tabStackView.arrangedSubviews[index] as? UIButton {
            currentButton.titleLabel?.font = .korFont(style: .bold, size: 16)
            currentButton.setTitleColor(.textColor, for: .normal)

            let selectedLine = UIView()
            selectedLine.backgroundColor = .textColor
            selectedLine.tag = 1
            currentButton.addSubview(selectedLine)
            selectedLine.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
    }
}

// MARK: - Bind
extension DictionaryDetailHeaderView {
    func bind(reactor: DictionaryDetailReactor) {
        tabStackView.arrangedSubviews.enumerated().forEach { index, view in
            guard let button = view as? UIButton else { return }
            button.rx.tap
                .map { DictionaryDetailReactor.Action.tabSelected(index) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
        
        reactor.state
            .map { $0.selectedTabIndex }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] index in
                self?.selectTab(index: index)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods
extension DictionaryDetailHeaderView {
    /// 탭을 생성하기 위해 주입 받는 함수
    /// - Parameter titles: DetailType을 배열로 받을지 vc에서 title만 mapping해서 넘길지 고민..
    func inject(titles: [DetailType]) {
        backgroundColor = .whiteMLS

        tabStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        titles.forEach { title in
            let button = UIButton(type: .system)
            button.setTitle(title.description, for: .normal)
            button.titleLabel?.font = .korFont(style: .regular, size: 16)
            button.setTitleColor(.neutral600, for: .normal)
            button.sizeToFit()
            tabStackView.addArrangedSubview(button)
        }

        if let reactor = reactor {
            bind(reactor: reactor)
        }
    }
}
