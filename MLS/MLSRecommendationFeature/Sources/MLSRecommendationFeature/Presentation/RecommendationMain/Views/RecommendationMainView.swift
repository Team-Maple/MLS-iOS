import UIKit

import MLSDesignSystem

import SnapKit

internal final class RecommendationMainView: UIView {
    // MARK: - Type
    private enum Constant {
    }

    // MARK: - Properties
    internal let header = Header(style: .main, title: "추천")
    internal let profileView = RecommendationProfileView()
    
    internal let profileImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    // MARK: - init
    init() {
        super.init(frame: .zero)

        addViews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension RecommendationMainView {
    func addViews() {
        addSubview(header)
        addSubview(profileView)
    }

    func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(21)
            make.horizontalEdges.equalToSuperview().inset(40)
        }
    }

    func configureUI() {}
}

