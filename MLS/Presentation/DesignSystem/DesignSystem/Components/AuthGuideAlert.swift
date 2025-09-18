import UIKit

import SnapKit

public class AuthGuideAlert: GuideAlert {
    // MARK: - Type
    private enum Constant {
        static let iconSize: CGFloat = 24
        static let topSpacing: CGFloat = 14
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

    private let subTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()

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
        label.attributedText = .makeStyledString(font: .cp_s_r, text: "북마크 컬렉션", color: .neutral700, alignment: .left)
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
        label.attributedText = .makeStyledString(font: .cp_s_r, text: "캐릭터 정보", color: .neutral700, alignment: .left)
        return label
    }()

    // MARK: - init
    public init(type: AuthGuideAlertType) {
        super.init(mainText: type.mainText, ctaText: type.ctaText, cancelText: "취소")
        addViews(type: type)
        setupConstraints(type: type)
        configureUI(type: type)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension AuthGuideAlert {
    func addViews(type: AuthGuideAlertType) {
        addSubview(contentStackView)

        contentStackView.addArrangedSubview(subTextLabel)
        if type == .withdraw {
            contentStackView.addArrangedSubview(bookmarkStackView)
            contentStackView.addArrangedSubview(characterStackView)
        }
    }

    func setupConstraints(type: AuthGuideAlertType) {
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(mainTextLabel.snp.bottom).offset(Constant.topSpacing)
            make.horizontalEdges.equalToSuperview().inset(GuideAlert.Constant.horizontalInset)
        }

        if type == .withdraw {
            contentStackView.setCustomSpacing(Constant.stackViewSpacing * 2, after: subTextLabel)
            contentStackView.setCustomSpacing(Constant.stackViewSpacing, after: bookmarkStackView)
        }

        buttonStackView.snp.remakeConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).offset(GuideAlert.Constant.verticalSpacing)
            make.horizontalEdges.equalToSuperview().inset(GuideAlert.Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(GuideAlert.Constant.verticalInset)
            make.height.equalTo(GuideAlert.Constant.buttonHeight)
        }
    }

    func configureUI(type: AuthGuideAlertType) {
        subTextLabel.attributedText = .makeStyledString(font: .b_s_r, text: type.subText, color: .neutral700)
    }
}
