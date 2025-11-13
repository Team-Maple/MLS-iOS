import UIKit

import DesignSystem

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class BaseErrorViewController: BaseViewController {
    // MARK: - Type
    private enum Constant {
        static let imageHeight: CGFloat = 171
        static let imageWidth: CGFloat = 165
        static let componentsSpacing: CGFloat = 24
        static let bottomButtonBottomSpacing: CGFloat = 16
        static let centerYMultiplied: CGFloat = 0.7
    }

    // MARK: - Properties
    private var disposeBag = DisposeBag()

    private let containerView: UIView = UIView()

    private let imageView: UIImageView = {
        let image = DesignSystemAsset.image(named: "errorImage")
        let view = UIImageView(image: image)
        return view
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = .makeStyledString(font: .b_m_r, text: "알 수 없는 오류가 발생했어요.\n이전 화면으로 돌아가 다시 시도해 주세요.")
        return label
    }()

    private let backButton = CommonButton(style: .normal, title: "뒤로가기", disabledTitle: nil)

    public override init() {
        super.init()
        modalPresentationStyle = .fullScreen
    }

    @MainActor public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension BaseErrorViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
        bind()
    }
}

// MARK: - SetUp
private extension BaseErrorViewController {
    func addViews() {
        view.addSubview(backButton)
        containerView.addSubview(imageView)
        containerView.addSubview(descriptionLabel)
        view.addSubview(containerView)
    }

    func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Constant.bottomButtonBottomSpacing)
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(Constant.imageHeight)
            make.width.equalTo(Constant.imageWidth)
            make.top.equalToSuperview().inset(Constant.componentsSpacing)
            make.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Constant.componentsSpacing)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(Constant.centerYMultiplied)
        }
    }

    func configureUI() { }

    func bind() {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
