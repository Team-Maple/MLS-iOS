import UIKit

import SnapKit

class ToggleLabel: UIView {
    let label = UILabel()
    let toggle: UISwitch = {
        let button = UISwitch()
        button.isOn = true
        return button
    }()

    init(text: String?) {
        super.init(frame: .zero)
        self.addSubview(label)
        self.addSubview(toggle)
        label.text = text

        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        toggle.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.verticalEdges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
