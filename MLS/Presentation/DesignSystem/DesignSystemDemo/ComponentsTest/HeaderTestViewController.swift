import UIKit

import DesignSystem

import SnapKit
import RxCocoa
import RxSwift

final class HeaderTestViewController: UIViewController {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private let headerView: HeaderView = {
        let view = HeaderView(textButtonTitle: "TextButton")
        return view
    }()
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.text = "Left"
        return label
    }()
    
    private let leftButtonHiddenToggle: UISwitch = {
        let button = UISwitch()
        button.isOn = true
        return button
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.text = "right"
        return label
    }()
    
    private let rightButtonHiddenToggle: UISwitch = {
        let button = UISwitch()
        button.isOn = true
        return button
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "text"
        return label
    }()
    
    private let textButtonHiddenToggle: UISwitch = {
        let button = UISwitch()
        button.isOn = true
        return button
    }()
    
    private let dividerView: DividerView = DividerView()
}

// MARK: - Life Cycle
extension HeaderTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews()
        self.setupContstraints()
        self.configureUI()
        self.bind()
    }
}

// MARK: - SetUp
private extension HeaderTestViewController {
    func addViews() {
        view.addSubview(headerView)
        view.addSubview(dividerView)
        view.addSubview(leftButtonHiddenToggle)
        view.addSubview(leftLabel)
        view.addSubview(rightButtonHiddenToggle)
        view.addSubview(rightLabel)
        view.addSubview(textButtonHiddenToggle)
        view.addSubview(textLabel)
    }

    func setupContstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        leftButtonHiddenToggle.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(30)
            make.trailing.equalToSuperview().inset(16)
        }
        leftLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalTo(leftButtonHiddenToggle)
        }
        rightButtonHiddenToggle.snp.makeConstraints { make in
            make.top.equalTo(leftButtonHiddenToggle.snp.bottom).offset(30)
            make.trailing.equalToSuperview().inset(16)
        }
        rightLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalTo(rightButtonHiddenToggle)
        }
        textButtonHiddenToggle.snp.makeConstraints { make in
            make.top.equalTo(rightButtonHiddenToggle.snp.bottom).offset(30)
            make.trailing.equalToSuperview().inset(16)
        }
        textLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalTo(textButtonHiddenToggle)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func bind() {
        leftButtonHiddenToggle.rx.isOn
            .withUnretained(self)
            .subscribe { (owner, isOn) in
                owner.headerView.leftButton.isHidden = !isOn
            }
            .disposed(by: disposeBag)
        
        rightButtonHiddenToggle.rx.isOn
            .withUnretained(self)
            .subscribe { (owner, isOn) in
                owner.headerView.rightButton.isHidden = !isOn
            }
            .disposed(by: disposeBag)
        
        textButtonHiddenToggle.rx.isOn
            .withUnretained(self)
            .subscribe { (owner, isOn) in
                owner.headerView.textButton.isHidden = !isOn
            }
            .disposed(by: disposeBag)
    }
}
