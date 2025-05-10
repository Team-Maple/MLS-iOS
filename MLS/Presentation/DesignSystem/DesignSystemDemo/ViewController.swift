import UIKit
import DesignSystem

import SnapKit

class ViewController: UIViewController {

    let checkButton = CheckButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        }
    }
}

