import Foundation
import Cocoa

final class MainComposer {
    let viewController: MainVC
    
    class func assemble(withInput input: MainInput) -> MainComposer {
        let presenter = MainPresenter(url: input.url)
        let viewController = MainVC(with: presenter)
        presenter.view = viewController
        return MainComposer.init(viewController: viewController)
    }

    private init(viewController: MainVC) {
        self.viewController = viewController
    }
}

struct MainInput {
    let url: URL
}

protocol MainViewInput: AnyObject {
    func makeRequest(_ request: URLRequest)
}

protocol MainViewOutput: AnyObject {
    func loadWebPage()
}
