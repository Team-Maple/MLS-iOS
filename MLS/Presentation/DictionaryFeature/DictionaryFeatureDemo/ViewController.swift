//
//  ViewController.swift
//  DictionaryFeatureDemo
//
//  Created by SeoJunYoung on 6/10/25.
//

import UIKit

import BaseFeature
import DictionaryFeature

class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        presentVC()
    }
    
    func presentVC() {
        let viewController = ItemFilterBottomSheetViewController()
        viewController.reactor = ItemFilterBottomSheetViewReactor()
        presentModal(viewController)
    }
}
