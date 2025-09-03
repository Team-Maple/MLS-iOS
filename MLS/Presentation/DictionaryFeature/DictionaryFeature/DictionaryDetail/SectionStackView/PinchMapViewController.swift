import UIKit

import BaseFeature

import RxCocoa
import RxSwift

class PinchMapViewController: BaseViewController {
    // MARK: - Properties
    public var disposeBag = DisposeBag()

    // MARK: - Components
    private var mainView = PinchMapView()

    public init(imageUrl: String) {
        super.init()
        mainView.setImage(imageUrl: imageUrl)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension PinchMapViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
        view.backgroundColor = .clearMLS

        mainView.scrollView.delegate = self

        mainView.backButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension PinchMapViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainView.imageView
    }
}
