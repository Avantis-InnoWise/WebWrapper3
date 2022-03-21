import Cocoa

extension String {
   
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}