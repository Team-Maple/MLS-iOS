import UIKit

import DesignSystem

internal import SnapKit

public final class OnBoardingNotificationView: UIView {
    // MARK: - Type
    private enum Constant {
        static let horizontalInset = 16
        static let verticalInset = 16
        static let imgSize = 160
        static let resizeCenterY = 70
    }
    
    // MARK: - Components
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "img_onBoarding_notification")
        return view
    }()
    
    private let boldTextLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h4, text: "메이플랜드에서 이벤트가 생기면\n알림을 보내드리고 있어요")
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.addSubview(imageView)
        view.addSubview(boldTextLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imgSize)
        }
        
        boldTextLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        return view
    }()
    
    private let nextButton = CommonButton(style: .normal, title: "다음", disabledTitle: "")
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension OnBoardingNotificationView {
    func addViews() {
        addSubview(contentView)
        addSubview(nextButton)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-Constant.resizeCenterY)
            make.horizontalEdges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(Constant.verticalInset)
        }
    }
    
    func configureUI() {
        addViews()
        setupConstraints()
        
        backgroundColor = .clearMLS
    }
}
