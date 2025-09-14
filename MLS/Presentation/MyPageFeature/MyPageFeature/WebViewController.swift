import UIKit
import WebKit

class WebViewController: UIViewController {
    private let urlString: String
    private let webView = WKWebView()
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
