import Cocoa
import WebKit

final class MainVC: NSViewController {
    // MARK: Constants
    
    private enum Constant {
        static let boxViewBorderWidth: CGFloat = 1
        static let boxViewBorderColor = NSColor.secondaryLabelColor
        static let boxViewHeigh: CGFloat = 70
        static let returnButtonbackgroundColor = NSColor.lightGray.cgColor
        static let returnButtonWidth: CGFloat = 80
        static let returnButtonHeigh: CGFloat = 30
        static let returnButtonLeftConstant:CGFloat = 30
        static let mainPageButtonBackgroundColor = NSColor.lightGray.cgColor
        static let mainPageButtonHeigh: CGFloat = 30
        static let mainPageButtonWidth: CGFloat = 120
        static let nextButtonBackgroundColor = NSColor.lightGray.cgColor
        static let nextButtonWidth: CGFloat = 80
        static let nextButtonHeigh: CGFloat = 30
        static let nextButtonRightConstant: CGFloat = -30
        static let viewWidth = 836
        static let viewHeigh = 644
    }
    
    // MARK: Subviews
    
    private lazy var boxView: NSBox = {
        let box = NSBox()
        box.boxType = .custom
        box.cornerRadius = .zero
        box.borderWidth = Constant.boxViewBorderWidth
        box.borderColor = Constant.boxViewBorderColor
        box.fillColor = .windowBackgroundColor
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()
    
    private lazy var returnButton: NSButton = {
        let button = NSButton()
        button.configure(title: Localized.buttonBackTitle, action: #selector(returnButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.layer?.backgroundColor = Constant.returnButtonbackgroundColor
        return button
    }()
    
    private lazy var mainPageButton: NSButton = {
        let button = NSButton()
        button.configure(title: Localized.buttonHomeTitle, action: #selector(mainPageButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer?.backgroundColor = Constant.mainPageButtonBackgroundColor
        return button
    }()
    
    private lazy var nextButton: NSButton = {
        let button = NSButton()
        button.configure(title: Localized.buttonForwardTitle, action: #selector(nextButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.layer?.backgroundColor = Constant.nextButtonBackgroundColor
        return button
    }()
    
    private lazy var webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupLayout()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now()) { [ weak self] in
            if let url = AppConstant.ApiConstant.baseUrl {
                self?.webView.load(URLRequest(url: url))
            }
        }
    }
    
    override func loadView() {
        view = NSView(frame: NSRect(origin: CGPoint(),
                                    size: CGSize(width: Constant.viewWidth,
                                                 height: Constant.viewHeigh)))
        view.layer?.backgroundColor = .white
    }
    
    // MARK: ButtonAction
    
    @objc private func returnButtonAction() {
        guard !returnButton.isEnabled
        else {
            webView.goBack()
            return
        }
    }
    
    @objc private func mainPageButtonAction() {
        guard let url = AppConstant.ApiConstant.baseUrl
        else { return }
        webView.load(URLRequest(url: url))
    }
    
    @objc private func nextButtonAction() {
        guard !nextButton.isEnabled
        else {
            webView.goForward()
            return
        }
    }
}

// MARK: Private methods
private extension MainVC {
    
    func addSubviews() {
        view.addSubview(boxView)
        view.addSubview(webView)
        boxView.addSubview(returnButton)
        boxView.addSubview(mainPageButton)
        boxView.addSubview(nextButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate(
            [
                boxView.widthAnchor.constraint(equalTo: view.widthAnchor),
                boxView.heightAnchor.constraint(equalToConstant: Constant.boxViewHeigh),
                boxView.topAnchor.constraint(equalTo: view.topAnchor),
                
                returnButton.widthAnchor.constraint(equalToConstant: Constant.returnButtonWidth),
                returnButton.heightAnchor.constraint(equalToConstant: Constant.returnButtonHeigh),
                returnButton.centerYAnchor.constraint(equalTo: boxView.centerYAnchor),
                returnButton.leftAnchor.constraint(equalTo: boxView.leftAnchor,
                                                   constant: Constant.returnButtonLeftConstant),
                
                mainPageButton.widthAnchor.constraint(equalToConstant: Constant.mainPageButtonWidth),
                mainPageButton.heightAnchor.constraint(equalToConstant: Constant.mainPageButtonHeigh),
                mainPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                mainPageButton.centerYAnchor.constraint(equalTo: boxView.centerYAnchor),
                
                nextButton.widthAnchor.constraint(equalToConstant: Constant.nextButtonWidth),
                nextButton.heightAnchor.constraint(equalToConstant: Constant.nextButtonHeigh),
                nextButton.centerYAnchor.constraint(equalTo: boxView.centerYAnchor),
                nextButton.rightAnchor.constraint(equalTo: boxView.rightAnchor,
                                                  constant: Constant.nextButtonRightConstant),
                
                webView.widthAnchor.constraint(equalTo: view.widthAnchor),
                webView.topAnchor.constraint(equalTo: boxView.bottomAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}

// MARK: WKNavigationDelegate
extension MainVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        returnButton.isEnabled = webView.backForwardList.backList.isEmpty ? false : true
        nextButton.isEnabled = webView.backForwardList.forwardList.isEmpty ? false : true
    }
}

// MARK: WKUIDelegate
extension MainVC: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == false {
            if let newURL = navigationAction.request.url {
                webView.load(URLRequest(url: newURL))
            }
        }
        return nil
    }
}
