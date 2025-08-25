//
//  MonsterDictionaryDetailView.swift
//  DictionaryFeature
//
//  Created by yeosong on 8/20/25.
//

import UIKit

class MonsterDictionaryDetailView: UIView {
    // 상세설명 메뉴에서 보여줄 상세 설명 스택 뷰
    public let detailDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 16

        return stackView
    }()
    
    // 출현 맵 메뉴에서 보여줄 출현 맵 스택 뷰
    public let detailMapStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .red
        stackView.axis = .vertical
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        addViews()
       // setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension MonsterDictionaryDetailView {
    func addViews() {
        addSubview(detailDescriptionStackView)
        addSubview(detailMapStackView)
    }
}
