//
//  ViewController.swift
//  DictionaryFeatureDemo
//
//  Created by SeoJunYoung on 6/10/25.
//

import UIKit

import BaseFeature
import DictionaryFeature

import RxCocoa
import RxSwift
import SnapKit

class ViewController: BaseViewController {

    let button = {
        let button = UIButton(type: .system)
        button.setTitle("present", for: .normal)
        return button
    }()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        button.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.presentVC()
            }
            .disposed(by: disposeBag)
    }

    func presentVC() {
        let viewController = ItemFilterBottomSheetViewController()
        viewController.reactor = ItemFilterBottomSheetViewReactor()
        present(viewController, animated: true)
    }
}
