import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

class ViewController: UIViewController {

    let checkButton = CheckButton(type: .small, title: "전체동의", subTitle: "(선택 약관 포함)")
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.center.equalToSuperview()
        }
        checkButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.checkButton.isSelected.toggle()
            }
            .disposed(by: disposeBag)
    }
}
