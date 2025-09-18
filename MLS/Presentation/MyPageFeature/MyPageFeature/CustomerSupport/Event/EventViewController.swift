import UIKit

final class EventViewController: CustomerSupportBaseViewController {
    private var currentTabIndex = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
    }

    func didSelecctMenuTab(index: Int) {
        guard index < 3 else { return }

        if currentTabIndex == index { return }
        currentTabIndex = index

        mainView.detailItemStackView.arrangedSubviews.forEach { subview in
            mainView.detailItemStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        if currentTabIndex == 0 {
            let items = [
                ("[진행중] 여름에는 시원한 Mapleland1", "2025년 07월 25일(금) 12:55"),
                ("[진행중] 여름에는 시원한 Mapleland2", "2025년 07월 25일(금) 12:55"),
                ("[진행중] 여름에는 시원한 Mapleland3", "2025년 07월 25일(금) 12:55")
            ]
            createDetailItem(items: items)
        } else {
            let items = [
                ("[종료] 여름에는 시원한 Mapleland1", "2025년 07월 25일(금) 12:55"),
                ("[종료] 여름에는 시원한 Mapleland2", "2025년 07월 25일(금) 12:55"),
                ("[종료] 여름에는 시원한 Mapleland3", "2025년 07월 25일(금) 12:55")
            ]
            createDetailItem(items: items)
        }
    }
}

extension EventViewController {
    func setupMenu() {
        let button = mainView.createMenuButton(title: "진행중인 이벤트", tag: 0)
        let button2 = mainView.createMenuButton(title: "종료된 이벤트", tag: 1)
        mainView.menuStackView.addArrangedSubview(button)
        mainView.menuStackView.addArrangedSubview(button2)

        button.rx.tap.bind { [weak self] _ in
            self?.menuTabTapped(button)
        }
        .disposed(by: disposeBag)

        button2.rx.tap.bind { [weak self] _ in
            self?.menuTabTapped(button2)
        }
        .disposed(by: disposeBag)
        // 메뉴 스택뷰 속 버튼들 왼쪽 정렬
        mainView.setupSpacerView()

        // 첫 진입 시 첫번째 버튼 클릭
        menuTabTapped(button)

    }

    private func menuTabTapped(_ sender: UIButton) {
        let selectedTag = sender.tag
        updateButtonStates(in: mainView.menuStackView, selectedTag: selectedTag)

//        // 이후 맞는 data로 detailItem들 다시 채우기
        didSelecctMenuTab(index: selectedTag)
    }

    // 버튼 상태 변경 함수
    private func updateButtonStates(in stackView: UIStackView, selectedTag: Int) {
        for (i, subview) in stackView.arrangedSubviews.enumerated() {
            guard let button = subview as? UIButton else { continue }
            let title = button.titleLabel?.text ?? ""

            let underline = button.subviews.first { $0.tag == 999999 }

            if i == selectedTag {
                button.setAttributedTitle(.makeStyledString(font: .sub_m_b, text: title, color: .black), for: .normal)
                underline?.isHidden = false
            } else {
                button.setAttributedTitle(.makeStyledString(font: .b_m_r, text: title, color: .neutral600), for: .normal)
                underline?.isHidden = true
            }
        }
    }
}
