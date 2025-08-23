import UIKit
import DomainInterface
import DesignSystem
class ItemDictionaryDetailViewController: DictionaryDetailBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .item
        titleText = "아이템 상세정보 테스트"
        inject(input: DictionaryDetailBaseViewController.Input(image: DesignSystemAsset.image(named: "testImage2"), backgroundColor: type.backgroundColor, name: "뇌전수리검", subText: "Lv10"))        
        //setupMenu(["상세 정보", "드롭 몬스터"])

    }
}
