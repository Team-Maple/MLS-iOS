import UIKit

import DesignSystem

import RxSwift
import SnapKit

final class ToastMakerTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    let imageView = UIImageView(image: .blur)

    let toast = Toast(message: "토스트 테스트")
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("블러", for: .normal)
        return btn
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Toast"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension ToastMakerTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addViews()
        self.setupConstraints()
        self.configureUI()
    }
}

// MARK: - SetUp
private extension ToastMakerTestViewController {
    func addViews() {
        view.addSubview(imageView)
        view.addSubview(toast)
        view.addSubview(button)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        toast.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(toast.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }

    func configureUI() {
        self.view.backgroundColor = .blue
        
        button.addAction(UIAction(handler: { [weak self] _ in
//            self?.toast.blurView.isHidden.toggle()
        }), for: .touchUpInside)
    }
}
