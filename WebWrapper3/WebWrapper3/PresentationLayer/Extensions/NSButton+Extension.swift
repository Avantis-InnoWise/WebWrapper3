import Cocoa

extension NSButton {
    func setup(
        with title: String = "Botton",
        color: NSColor = NSColor(red: 255/255, green: 51/255, blue: 153/255, alpha: 1),
        radius: CGFloat = 10,
        action: Selector?
    ) {
        self.title = title
        self.action = action
        
        bezelStyle = .texturedSquare
        wantsLayer = true
        isBordered = false
        layer?.backgroundColor = color.cgColor
        layer?.masksToBounds = true
        layer?.cornerRadius = radius
    }
}
