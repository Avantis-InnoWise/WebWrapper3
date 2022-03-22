import Cocoa

extension NSButton {
    func configure(title: String = "Botton", color: NSColor = .init(red: 255/255, green: 51/255, blue: 153/255, alpha: 1), radius: CGFloat = 10, action: Selector?) {
        self.title = title
        self.action = action
        self.bezelStyle = .texturedSquare
        self.wantsLayer = true
        self.isBordered = false
        self.layer?.backgroundColor = color.cgColor
        self.layer?.masksToBounds = true
        self.layer?.cornerRadius = radius
    }
}
