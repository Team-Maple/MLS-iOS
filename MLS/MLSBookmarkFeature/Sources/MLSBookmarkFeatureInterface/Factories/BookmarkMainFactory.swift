import MLSCore

import UIKit

public protocol BookmarkMainFactory {
    func make(bottomInset: CGFloat) -> BaseViewController
}
