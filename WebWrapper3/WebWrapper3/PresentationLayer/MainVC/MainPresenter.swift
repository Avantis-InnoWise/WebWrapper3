import Foundation

final class MainPresenter {
    // MARK: Properties
    
    weak var view: MainViewInput!
    private let url: URL
    
    // MARK: Lifecycle
    
    init(url: URL) {
        self.url = url
    }
}

// MARK: MainViewOutput
extension MainPresenter: MainViewOutput {
    func loadWebPage() {
        let request = URLRequest(url: url)
        view.makeRequest(request)
    }
}
