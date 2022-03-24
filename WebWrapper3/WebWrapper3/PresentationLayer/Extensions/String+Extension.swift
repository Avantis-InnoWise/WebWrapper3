import Cocoa

extension String {
    var localizedValue: String {
        NSLocalizedString(self, comment: "")
    }
}
