import UIKit
import SafariServices

public final class WebViewController {

    public static func make(urlString: String) -> SFSafariViewController? {
        guard let url = URL(string: urlString) else { return nil }
        return SFSafariViewController(url: url)
    }
}
