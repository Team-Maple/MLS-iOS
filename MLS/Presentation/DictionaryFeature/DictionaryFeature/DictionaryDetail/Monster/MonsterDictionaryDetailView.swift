//
//  MonsterDictionaryDetailView.swift
//  DictionaryFeature
//
//  Created by yeosong on 8/20/25.
//

import UIKit
import DesignSystem

class MonsterDictionaryDetailView: UIView {
    // MARK: - Type
    enum Constant {
        static let descriptionCornerRadius: CGFloat = 16
        static let descriptionStackViewInset: UIEdgeInsets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        static let descriptionStackViewHeight: CGFloat = 50
        static let horizontalInset: CGFloat = 10
        static let dividerHeight: CGFloat = 1
        static let descriptionStackViewTopMargin: CGFloat = 20
        static let descriptionStackViewHorizontalInset: CGFloat = 16
    }
    // 상세설명 메뉴에서 보여줄 상세 설명 스택 뷰
    public let detailDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .white
        stackView.distribution = .fill
        stackView.layer.cornerRadius = Constant.descriptionCornerRadius

        return stackView
    }()
    
    // 출현 맵 메뉴에서 보여줄 출현 맵 스택 뷰
    public let detailMapStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        addViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
extension MonsterDictionaryDetailView {
    func addViews() {
        addSubview(detailDescriptionStackView)
        addSubview(detailMapStackView)
    }
    
    // 출현 맵 뷰 생성(임시)
    func makeSpawnMapView() {
        let label = UILabel()
        label.text = "출현 맵 정보 표시"
        label.textAlignment = .center
        detailMapStackView.addArrangedSubview(label)
    }
    
    func detailDescriptionTextViewSetup() -> UIStackView{
        let stackView = UIStackView()
        let dividerView = DividerView()
        // 가로 스택 뷰
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing // 좌우 label 사이 간격 고르게
        stackView.alignment = .center
        // 내부 패딩값 주기
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.descriptionStackViewInset
        
        detailDescriptionStackView.addArrangedSubview(stackView)
        detailDescriptionStackView.addArrangedSubview(dividerView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.descriptionStackViewHeight)
        }
        
        dividerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.dividerHeight)
        }
        return stackView
    }
}


