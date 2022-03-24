import Cocoa
import WebKit

final class MainVC: NSViewController {
    
    lazy private var returnButton = setupButtonBack()
    lazy private var mainPageButton = setupButtonHome()
    lazy private var nextButton = setupButtonForward()
    
    lazy private var boxView: NSBox = setupBoxView()
    lazy private var webView: WKWebView = setupWebView()
    
    override func loadView() {
        self.view = NSView(frame: NSRect(origin: CGPoint(), size: CGSize(width: 836, height: 644)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let url = baseUrl {
                self.webView.load(URLRequest(url: url))
            }
        }
    }
    
    private func setupView() {
        self.view.layer?.backgroundColor = .white
        self.addSubviews()
        self.setupLayout()
    }
    
    @objc private func returnButtonAction() {
        if returnButton.isEnabled { webView.goBack() }
    }
    
    @objc private func mainPageButtonAction() {
        if let url = baseUrl { self.webView.load(URLRequest(url: url)) }
    }

    @objc private func nextButtonAction() {
        if nextButton.isEnabled { webView.goForward() }
    }
}

//MARK: Setup components for MainViewController
private extension MainVC {
    
    func setupButtonBack() -> NSButton {
        let button = NSButton()
        button.configure(title: Localized.buttonBackTitle, action: #selector(returnButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.layer?.backgroundColor = NSColor.lightGray.cgColor
        return button
    }
    
    func setupButtonHome() -> NSButton {
        let button = NSButton()
        button.configure(title: Localized.buttonHomeTitle, action: #selector(mainPageButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer?.backgroundColor = NSColor.lightGray.cgColor
        return button
    }
    
    func setupButtonForward() -> NSButton {
        let button = NSButton()
        button.configure(title: Localized.buttonForwardTitle, action: #selector(nextButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.layer?.backgroundColor = NSColor.lightGray.cgColor
        return button
    }
    
    func setupBoxView() -> NSBox {
        let box = NSBox()
        box.boxType = .custom
        box.cornerRadius = 0
        box.borderWidth = 1
        box.borderColor = NSColor.secondaryLabelColor
        box.fillColor = .windowBackgroundColor
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }
    
    func setupWebView() -> WKWebView {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }
    
    func addSubviews() {
        self.view.addSubview(boxView)
        self.view.addSubview(webView)
        self.boxView.addSubview(returnButton)
        self.boxView.addSubview(mainPageButton)
        self.boxView.addSubview(nextButton)
    }
    
    func setupLayout() {
        boxView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        boxView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        boxView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        returnButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        returnButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        returnButton.centerYAnchor.constraint(equalTo: self.boxView.centerYAnchor).isActive = true
        returnButton.leftAnchor.constraint(equalTo: self.boxView.leftAnchor, constant: 30).isActive = true
        
        mainPageButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        mainPageButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        mainPageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainPageButton.centerYAnchor.constraint(equalTo: self.boxView.centerYAnchor).isActive = true
        
        nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: self.boxView.centerYAnchor).isActive = true
        nextButton.rightAnchor.constraint(equalTo: self.boxView.rightAnchor, constant: -30).isActive = true
        
        webView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: self.boxView.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

//MARK: WKNavigationDelegate
extension MainVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        returnButton.isEnabled = webView.backForwardList.backList.isEmpty ? false : true
        nextButton.isEnabled = webView.backForwardList.forwardList.isEmpty ? false : true
    }
}

//MARK: WKUIDelegate
extension MainVC: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == false {
            if let newURL = navigationAction.request.url {
                self.webView.load(URLRequest(url: newURL))
            }
        }
        return nil
    }
}
