import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

public final class TabBarUnderlineController {
    // MARK: - UI Components

    /// 선택된 탭 아래를 표시하는 인디케이터 뷰
    private let selectionIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .textColor
        return view
    }()

    /// 탭 바 하단의 구분선
    private let bottomUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral300
        return view
    }()

    // MARK: - Properties

    private var collectionView: UICollectionView?
    private let disposeBag = DisposeBag()

    /// 현재 컬렉션 뷰의 스크롤 오프셋 (인디케이터 위치 계산용)
    private var currentScrollOffset: CGPoint?

    // MARK: - Initialization

    public init() {}

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

private extension TabBarUnderlineController {
    func addIndicatorViews(to collectionView: UICollectionView) {
        guard let superview = collectionView.superview else { return }

        superview.addSubview(bottomUnderlineView)
        bottomUnderlineView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(collectionView)
            make.height.equalTo(1)
        }

        superview.addSubview(selectionIndicatorView)
        selectionIndicatorView.frame = CGRect(
            x: 0,
            y: collectionView.frame.maxY - 2,
            width: 0,
            height: 2
        )
    }
}

// MARK: - Public Interface

public extension TabBarUnderlineController {
    /// 컬렉션 뷰에 인디케이터 컨트롤러 연결
    func configure(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        addIndicatorViews(to: collectionView)
    }

    /// 컬렉션 뷰 스크롤 오프셋이 변경될 때 호출 (scrollViewDidScroll 등에서)
    func updateScrollOffset(_ offset: CGPoint) {
        currentScrollOffset = offset
        updateIndicatorFrameWithoutAnimation()
    }

    /// 선택된 셀 위치에 인디케이터를 즉시 이동
    func updateIndicatorFrameWithoutAnimation() {
        guard let collectionView,
              let indexPath = collectionView.indexPathsForSelectedItems?.first,
              let selectedFrame = collectionView.cellForItem(at: indexPath)?.frame
        else { return }

        let xOffset = selectedFrame.minX - (currentScrollOffset?.x ?? 0)
        selectionIndicatorView.frame.origin.x = xOffset
    }

    /// 선택된 셀 위치로 인디케이터를 애니메이션으로 이동
    func animateIndicatorToSelectedItem() {
        guard let collectionView,
              let indexPath = collectionView.indexPathsForSelectedItems?.first,
              let selectedFrame = collectionView.cellForItem(at: indexPath)?.frame
        else { return }

        let xOffset = selectedFrame.minX - (currentScrollOffset?.x ?? 0)
        let targetFrame = CGRect(
            x: xOffset,
            y: collectionView.frame.maxY - 2,
            width: selectedFrame.width,
            height: 2
        )

        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            self?.selectionIndicatorView.frame = targetFrame
        })
    }

    /// 선택된 셀 위치로 인디케이터를 애니메이션으로 이동
    func setInitialIndicator() {
        guard let collectionView,
              let indexPath = collectionView.indexPathsForSelectedItems?.first,
              let selectedFrame = collectionView.cellForItem(at: indexPath)?.frame
        else { return }

        let xOffset = selectedFrame.minX - (currentScrollOffset?.x ?? 0)
        let targetFrame = CGRect(
            x: xOffset,
            y: collectionView.frame.maxY - 2,
            width: selectedFrame.width,
            height: 2
        )
        selectionIndicatorView.frame = targetFrame
    }

    func setHidden(hidden: Bool, animated: Bool = false) {
        let alpha: CGFloat = hidden ? 0 : 1
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.selectionIndicatorView.alpha = alpha
                self.bottomUnderlineView.alpha = alpha
            }
        } else {
            selectionIndicatorView.alpha = alpha
            bottomUnderlineView.alpha = alpha
        }

        selectionIndicatorView.isHidden = hidden
        bottomUnderlineView.isHidden = hidden
    }
}
