import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let url = AppConstant.ApiConstant.baseUrl else { return }
        let mainInput = MainInput(url: url)
        let mainComposer = MainComposer.assemble(withInput: mainInput)
        changeRootVC(to: mainComposer.viewController)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

extension AppDelegate {
    func changeRootVC(to vc: NSViewController) {
        self.window = NSWindow(contentRect: NSScreen.main?.frame ?? NSRect(),
                               styleMask: [.miniaturizable, .closable, .resizable, .titled],
                               backing: .buffered,
                               defer: false)
        guard let window = window else { return }
        window.contentViewController = vc
        window.title = Localization.appTitle
        window.makeKeyAndOrderFront(nil)
    }
}
