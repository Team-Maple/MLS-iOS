import UIKit

internal import SnapKit

public class CheckButton: UIView {

    enum DesignSystemAsset {
        static func image(named name: String) -> UIImage? {
            let bundle = Bundle(for: CheckButton.self)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
    }

    private let checkImageView = UIImageView(image: DesignSystemAsset.image(named: "checkicon")?.withRenderingMode(.alwaysTemplate))

    public init() {
        super.init(frame: .zero)
        self.addSubview(checkImageView)
        checkImageView.tintColor = .red
        checkImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    func tinted(with color: UIColor) -> UIImage {
        return self.withRenderingMode(.alwaysTemplate).withTintColor(color)
    }
}
