import UIKit

import DesignSystem

import SnapKit
import RxCocoa
import RxSwift

final class CheckButtonTestViewController: UIViewController {
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var bigCheckButton = CheckButton(type: .big, title: nil, subTitle: nil)
    private var smallCheckButton = CheckButton(type: .small, title: nil, subTitle: nil)
    
    private let typeSegmentControl: UISegmentedControl = {
        let items = ["BIG", "SMALL"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let mainTitleTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "MainTitle"
        view.text = "MainTitle"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let subTitleTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "SubTitle"
        view.text = "SubTitle"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let mainTitleTextLabel: UILabel = {
        let label = UILabel()
        label.text = "MainTitle"
        return label
    }()
    
    private let subTitleTextLabel: UILabel = {
        let label = UILabel()
        label.text = "SubTitle"
        return label
    }()
}

// MARK: - Life Cycle
extension CheckButtonTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViews()
        self.setupContstraints()
        self.configureUI()
        self.bind()
    }
}

// MARK: - SetUp
private extension CheckButtonTestViewController {
    func addViews() {
        view.addSubview(bigCheckButton)
        view.addSubview(smallCheckButton)
        view.addSubview(typeSegmentControl)
        view.addSubview(mainTitleTextLabel)
        view.addSubview(mainTitleTextField)
        view.addSubview(subTitleTextLabel)
        view.addSubview(subTitleTextField)
    }

    func setupContstraints() {
        bigCheckButton.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        smallCheckButton.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        typeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(bigCheckButton.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        mainTitleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(typeSegmentControl.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        mainTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(mainTitleTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        subTitleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitleTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        subTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func bind() {
        bigCheckButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.bigCheckButton.isSelected.toggle()
            }
            .disposed(by: disposeBag)
        
        smallCheckButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.smallCheckButton.isSelected.toggle()
            }
            .disposed(by: disposeBag)
        
        typeSegmentControl.rx.selectedSegmentIndex
            .withUnretained(self)
            .subscribe { (owner, index) in
                if index == 0 {
                    owner.bigCheckButton.isHidden = false
                    owner.smallCheckButton.isHidden = true
                } else {
                    owner.bigCheckButton.isHidden = true
                    owner.smallCheckButton.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        mainTitleTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.bigCheckButton.title = text
                owner.smallCheckButton.title = text
            }
            .disposed(by: disposeBag)
        
        subTitleTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.bigCheckButton.subTitle = text
            }
            .disposed(by: disposeBag)
    }
}
