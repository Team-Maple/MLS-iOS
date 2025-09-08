import UIKit

import BaseFeature
import DesignSystem

import RxSwift

final class CardListTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let cardList = CardList()

    private let mainTextTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "main"
        view.text = "text"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let mainTextTextLabel: UILabel = {
        let label = UILabel()
        label.text = "main"
        return label
    }()

    private let subTextTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "sub"
        view.text = "text"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let subTextTextLabel: UILabel = {
        let label = UILabel()
        label.text = "sub"
        return label
    }()

    private let cardListToggle = ToggleBox(text: "isBookmark")

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "CardList"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension CardListTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
        bind()
    }
}

// MARK: - SetUp
private extension CardListTestViewController {
    func addViews() {
        view.addSubview(cardList)
        view.addSubview(mainTextTextLabel)
        view.addSubview(mainTextTextField)
        view.addSubview(subTextTextLabel)
        view.addSubview(subTextTextField)
        view.addSubview(cardListToggle)
    }

    func setupConstraints() {
        cardList.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        mainTextTextLabel.snp.makeConstraints { make in
            make.top.equalTo(cardList.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        mainTextTextField.snp.makeConstraints { make in
            make.top.equalTo(mainTextTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        subTextTextLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTextTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        subTextTextField.snp.makeConstraints { make in
            make.top.equalTo(subTextTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        cardListToggle.snp.makeConstraints { make in
            make.top.equalTo(subTextTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
        ImageLoader.shared.loadImage(stringURL: "https://maplestory.io/api/gms/62/mob/2100101/render/stand") { [weak self] image in
            if let image {
                DispatchQueue.main.async {
                    self?.cardList.setImage(image: image, backgroundColor: .listMap)
                }
            } else {
                print("fail to load image")
            }
        }
    }

    func bind() {
        mainTextTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.cardList.mainText = text
            }
            .disposed(by: disposeBag)

        subTextTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.cardList.subText = text
            }
            .disposed(by: disposeBag)

        cardListToggle.toggle.rx.isOn
            .withUnretained(self)
            .subscribe { (owner, isOn) in
                owner.cardList.isIconSelected = isOn
            }
            .disposed(by: disposeBag)
    }
}
