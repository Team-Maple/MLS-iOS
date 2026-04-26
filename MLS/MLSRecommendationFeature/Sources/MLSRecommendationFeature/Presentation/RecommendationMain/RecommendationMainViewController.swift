import UIKit

import MLSCore

public final class RecommendationMainViewController: BaseViewController {

    // MARK: - Init

    public override init() {
        super.init()
    }

    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - SetUp

private extension RecommendationMainViewController {
    func setupUI() {
        view.backgroundColor = .red
    }
}
