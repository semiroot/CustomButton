import Cocoa

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet private var window: NSWindow!

	func applicationDidFinishLaunching(_ notification: Notification) {
		let button = CustomButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.title = "Button Example"
        button.textPosition = .left
        button.textMargin = 5
        
        button.imageMargin = 3
        button.image = NSImage(named: NSImage.Name("Icon"))
        
        button.textColorLight = .black
        button.textColorDark = .white
        button.activeTextColorLight = .darkGray
        button.activeTextColorDark = .lightGray
        
        button.activeBackgroundColorLight = .black
        button.activeBackgroundColorDark = .white
        button.backgroundColorLight = .darkGray
        button.backgroundColorDark = .lightGray
        
        button.activeBorderColorLight = .darkGray
        button.activeBorderColorDark = .lightGray
        button.borderColorLight = .black
        button.borderColorDark = .white
        
        button.cornerTopLeft = true
        button.cornerTopRight = false
        button.cornerBottomLeft = true
        button.cornerBottomRight = false
        
        button.borderWidth = 2
        button.cornerRadius = 10
        
        button.animateState = true

		let contentView = window.contentView!
		contentView.addSubview(button)

		NSLayoutConstraint.activate([
			button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			button.widthAnchor.constraint(equalToConstant: 200),
			button.heightAnchor.constraint(equalToConstant: 22)
		])
	}
}
