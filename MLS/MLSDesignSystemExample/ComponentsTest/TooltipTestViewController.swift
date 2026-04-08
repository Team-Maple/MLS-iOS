import UIKit

import MLSDesignSystem

import RxCocoa
import RxSwift
import SnapKit

final class TooltipTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    let button1 = {
        let button = UIButton(type: .system)
        button.setTitle("우상단 버튼입니다", for: .normal)
        return button
    }()
    
    let button2 = {
        let button = UIButton(type: .system)
        button.setTitle("좌상단", for: .normal)
        return button
    }()
    
    
    let button3 = {
        let button = UIButton(type: .system)
        button.setTitle("우하단", for: .normal)
        return button
    }()
    
    let button4 = {
        let button = UIButton(type: .system)
        button.setTitle("좌하단", for: .normal)
        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "툴팁"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension TooltipTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        addViews()
        setupConstraints()
        bind()
    }
}

// MARK: - SetUp
private extension TooltipTestViewController {
    func addViews() {
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(button4)
    }

    func setupConstraints() {
        button1.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        button2.snp.makeConstraints { make in
            make.top.equalTo(button1.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        button3.snp.makeConstraints { make in
            make.top.equalTo(button2.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        button4.snp.makeConstraints { make in
            make.top.equalTo(button3.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    func bind() {
        button1.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                TooltipFactory.show(text: "같은 레벨·직업 유저들이 자주 언급한\n사냥터를 기반으로 추천해요.", anchorView: owner.button1, tooltipPosition: .topLeading
                )
            }
            .disposed(by: disposeBag)
        
        button2.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                TooltipFactory.show(text: "같은 레벨·직업 유저들이 자주 언급한\n사냥터를 기반으로 추천해요.", anchorView: owner.button2, tooltipPosition: .topTrailing
                )
            }
            .disposed(by: disposeBag)
        
        button3.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                TooltipFactory.show(text: "같은 레벨·직업 유저들이 자주 언급한\n사냥터를 기반으로 추천해요.", anchorView: owner.button3, tooltipPosition: .bottomLeading
                )
            }
            .disposed(by: disposeBag)
        
        button4.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                TooltipFactory.show(text: "같은 레벨·직업 유저들이 자주 언급한\n사냥터를 기반으로 추천해요.", anchorView: owner.button4, tooltipPosition: .bottomTrailing
                )
            }
            .disposed(by: disposeBag)
    }
}
