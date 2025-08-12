import UIKit

import DesignSystem

import SnapKit

// MARK: - MyPage View
final class MyPageView: UIView {
    public let headerView = Header(style: .main, title: "마이페이지")
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage") // mock 이미지
        return imageView
    }()
    // 프로필 이름 label
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_l_b, text: "익명의 오무라이스케챱", color: .black)
        return label
    }()
    // 프로필 수정 버튼
    let editProfileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(hexCode: "#FF5C00", alpha: 1)
        button.layer.cornerRadius = 8
        return button
    }()
    // 프로필 수정 버튼 label
    private let editProfileButtonLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .btn_m_b, text: "프로필 수정", color: .init(hexCode: "#FFFFFF"))
        return label
    }()
    
    // 섹션 스택 뷰 (설정, 고객지원 section들 들어갈 스택 뷰)
    let sectionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical // 세로 스택 뷰
        stackView.spacing = 16
        stackView.backgroundColor = .init(hexCode: "#F5F5F5")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // 알림 설정 버튼
    private let notificationSettingButton: UIButton = {
        let button = UIButton()
        button.setTitle("알림 설정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .b_m_r
        return button
    }()
    
    // 캐릭터 정보 설정 버튼
    private let characterSettingButton: UIButton = {
        let button = UIButton()
        button.setTitle("캐릭터 정보 설정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .b_m_r
        return button
    }()
    
    public init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
// MARK: - View Setup
private extension MyPageView {
    // subView 추가
    func addViews() {
        addSubview(headerView)
        addSubview(scrollView)
        // 스크롤 뷰 위에 뷰 추가
        [profileImageView, profileNameLabel, editProfileButton, sectionStackView].forEach {
            scrollView.addSubview($0)
        }
        editProfileButton.addSubview(editProfileButtonLabel)
    }
    
    // 제약조건 setup
    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(104)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(profileNameLabel.snp.bottom).offset(12)
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        editProfileButtonLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        sectionStackView.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}
