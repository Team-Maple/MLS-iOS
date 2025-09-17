import UIKit

import SnapKit

public class AuthGuideAlert: GuideAlert {
    // MARK: - Type
    private enum Constant {
        static let iconSize: CGFloat = 24
        static let logoutSpacing: CGFloat = 7
        static let withdrawSpacing: CGFloat = 14
        static let stackViewSpacing: CGFloat = 8
        static let iconSpacing: CGFloat = 5
    }
    
    public enum AuthGuideAlertType {
        case logout
        case withdraw
        
        var mainText: String {
            switch self {
            case .logout:
                "정말 로그아웃 하시겠어요?"
            case .withdraw:
                "정말 탈퇴 하시겠어요?"
            }
        }
        
        var subText: String {
            switch self {
            case .logout:
                "로그아웃하면 저장한 캐릭터,\n북마크한 아이템 정보를 볼 수 없어요."
            case .withdraw:
                "탈퇴 시, 아래 정보가 삭제 되어 복구가 불가능해요."
            }
        }
        
        var ctaText: String {
            switch self {
            case .logout:
                "로그아웃 하기"
            case .withdraw:
                "탈퇴하기"
            }
        }
    }
    
    // MARK: - Components
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private let subTextLabel = UILabel()
    
    private lazy var bookmarkStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [bookmarkCheckIcon, bookmarkLabel])
        view.axis = .horizontal
        view.spacing = Constant.stackViewSpacing
        
        bookmarkCheckIcon.snp.makeConstraints { make in
            make.size.equalTo(Constant.iconSize)
        }
        
        return view
    }()
    private let bookmarkCheckIcon: UIImageView = {
        let view = UIImageView(image: .checkMarkFill)
        return view
    }()
    
    private let bookmarkLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .cp_s_r, text: "북마크 컬렉션", color: .neutral700)
        return label
    }()
    
    private lazy var characterStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [characterCheckIcon, characterLabel])
        view.axis = .horizontal
        view.spacing = Constant.stackViewSpacing
        
        characterCheckIcon.snp.makeConstraints { make in
            make.size.equalTo(Constant.iconSize)
        }
        
        return view
    }()
    private let characterCheckIcon: UIImageView = {
        let view = UIImageView(image: .checkMarkFill)
        return view
    }()
    
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .cp_s_r, text: "캐릭터 정보", color: .neutral700)
        return label
    }()

    // MARK: - init
    public init(type: AuthGuideAlertType) {
        super.init(mainText: type.mainText, ctaText: type.ctaText, cancelText: "취소")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension AuthGuideAlert {
    func addViews(type: AuthGuideAlertType) {
        contentStackView.addArrangedSubview(subTextLabel)
        if type == .withdraw {
            contentStackView.addArrangedSubview(bookmarkStackView)
            contentStackView.addArrangedSubview(characterStackView)
        }
            
    }

    func setupConstraints(type: AuthGuideAlertType) {
        switch type {
        case .logout:
            contentStackView.snp.makeConstraints { make in
                make.top.equalTo(mainTextLabel.snp.bottom).offset(Constant.logoutSpacing)
                make.horizontalEdges.equalToSuperview().inset(GuideAlert.Constant.horizontalInset)
            }
        case .withdraw:
            contentStackView.setCustomSpacing(Constant.withdrawSpacing * 2, after: subTextLabel)
            contentStackView.setCustomSpacing(Constant.withdrawSpacing, after: bookmarkStackView)
            
            contentStackView.snp.makeConstraints { make in
                make.top.equalTo(mainTextLabel.snp.bottom).offset(Constant.logoutSpacing * 2)
                make.horizontalEdges.equalToSuperview().inset(GuideAlert.Constant.horizontalInset)
            }
        }
        
        buttonStackView.snp.updateConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).offset(GuideAlert.Constant.verticalSpacing)
        }
    }

    func configureUI(type: AuthGuideAlertType) {
        subTextLabel.attributedText = .makeStyledString(font: .cp_s_r, text: type.subText, color: .neutral700)
    }
}
