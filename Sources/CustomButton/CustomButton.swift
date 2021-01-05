import Cocoa

@IBDesignable
open class CustomButton: NSButton {
    
    // MARK: - State Functionality
    public var isPressed: Bool = false {
        didSet {
            //alphaValue = isPressed ? 1 : 0.6
            animateColor()
        }
    }
    
    private var isLightAppearanc: Bool {
        let appearanceName = NSApp.effectiveAppearance.name
        return appearanceName == NSAppearance.Name.aqua || appearanceName == NSAppearance.Name.vibrantLight
    }
    
    private func toggleState() {
        state = state == .off ? .on : .off
        animateColor()
    }
    
    private var isOn: Bool { state == .on }
    

    // MARK: - Text Functionality
    private let titleLayer = CATextLayer()
    
    @IBInspectable public var titleMargin: CGFloat = 10

	@IBInspectable public var titleColorLight: NSColor = .labelColor
    @IBInspectable public var titleColorDark: NSColor = .labelColor
    @IBInspectable public var titleColor: NSColor = .clear {
        didSet {
            titleColorDark = titleColor
            titleColorLight = titleColor
        }
    }
    
    @IBInspectable public var titleColorLightActive: NSColor = .labelColor
    @IBInspectable public var titleColorDarkActive: NSColor = .labelColor
    @IBInspectable public var titleColorActive: NSColor = .clear {
        didSet {
            titleColorDarkActive = titleColorActive
            titleColorLightActive = titleColorActive
        }
    }
    
    @IBInspectable override public var title: String {
        didSet { setTitle() }
    }
    
    override public var font: NSFont? {
        didSet { setTitle() }
    }
    
    private func getTitleColor() -> NSColor {
        if isLightAppearanc {
            return isOn || isPressed ? titleColorLightActive : titleColorLight
        } else {
            return isOn || isPressed ? titleColorDarkActive : titleColorDark
        }
    }
    
    private func setTitle() {
        titleLayer.string = title

        if let font = font {
            titleLayer.font = font
            titleLayer.fontSize = font.pointSize
        }

        needsLayout = true
    }
    
    
    // MARK: - Icon Functionality
    private let iconLayer = CALayer()
    private let iconMaskLayer = CALayer()
    
    @IBInspectable public var iconMargin: CGFloat = 8
    @IBInspectable public var icon: NSImage? {
        didSet { setIcon() }
    }
    
    private func setIcon() {
        guard let icon = icon else { return }
        iconMaskLayer.contents = icon.layerContents(forContentsScale: window?.backingScaleFactor ?? 2)
        needsLayout = true
    }
    
    
    // MARK: - Background Functionality
    @IBInspectable public var backgroundColorLight: NSColor = .clear
    @IBInspectable public var backgroundColorDark: NSColor = .clear
    @IBInspectable public var backgroundColor: NSColor = .clear {
        didSet {
            backgroundColorLight = backgroundColor
            backgroundColorDark = backgroundColor
        }
    }
    
    @IBInspectable public var backgroundColorLightActive: NSColor? = .clear
    @IBInspectable public var backgroundColorDarkActive: NSColor? = .clear
    @IBInspectable public var backgroundColorActive: NSColor = .clear {
        didSet {
            backgroundColorLightActive = backgroundColorActive
            backgroundColorDarkActive = backgroundColorActive
        }
    }
    
    private func getBackgroundColor() -> NSColor {
        if isLightAppearanc {
            return isOn || isPressed ? (backgroundColorLightActive ?? backgroundColorLight) : backgroundColorLight
        } else {
            return isOn || isPressed ? (backgroundColorDarkActive ?? backgroundColorDark) : backgroundColorDark
        }
    }
    
    
    // MARK: - Border Functionality
    @IBInspectable public var cornerTopLeft: Bool = true {
        didSet {
            if cornerTopLeft {
                layer?.maskedCorners.insert(.layerMinXMinYCorner)
            } else {
                layer?.maskedCorners.subtract(.layerMinXMinYCorner)
            }
        }
    }
    
    @IBInspectable public var cornerTopRight: Bool = true {
        didSet {
            if cornerTopRight {
                layer?.maskedCorners.insert(.layerMaxXMinYCorner)
            } else {
                layer?.maskedCorners.subtract(.layerMaxXMinYCorner)
            }
        }
    }
    
    @IBInspectable public var cornerBottomLeft: Bool = true {
        didSet {
            if cornerBottomLeft {
                layer?.maskedCorners.insert(.layerMinXMaxYCorner)
            } else {
                layer?.maskedCorners.subtract(.layerMinXMaxYCorner)
            }
        }
    }
    
    @IBInspectable public var cornerBottomRight: Bool = true {
        didSet {
            if cornerBottomRight {
                layer?.maskedCorners.insert(.layerMaxXMaxYCorner)
            } else {
                layer?.maskedCorners.subtract(.layerMaxXMaxYCorner)
            }
        }
    }
    
	@IBInspectable public var cornerRadius: Double = 0 {
		didSet { layer?.cornerRadius = CGFloat(cornerRadius) }
	}

	@IBInspectable public var hasContinuousCorners: Bool = true {
		didSet {
			if #available(macOS 10.15, *) {
				layer?.cornerCurve = hasContinuousCorners ? .continuous : .circular
			}
		}
	}

	@IBInspectable public var borderWidth: Double = 0 {
		didSet { layer?.borderWidth = CGFloat(borderWidth) }
    }
    
    @IBInspectable public var borderColorLight: NSColor = .clear
    @IBInspectable public var borderColorDark: NSColor = .clear
	@IBInspectable public var borderColor: NSColor = .clear {
		didSet {
            borderColorLight = borderColor
            borderColorDark = borderColor
		}
	}

    @IBInspectable public var borderColorLightActive: NSColor = .clear
    @IBInspectable public var borderColorDarkActive: NSColor = .clear
	@IBInspectable public var borderColorActive: NSColor = .clear {
		didSet {
            borderColorLightActive = borderColorActive
            borderColorDarkActive = borderColorActive
		}
	}
    
    private func getBorderColor() -> NSColor {
        if isLightAppearanc {
            return isOn || isPressed ? borderColorLightActive : borderColorLight
        } else {
            return isOn || isPressed ? borderColorDarkActive : borderColorDark
        }
    }
    
    
    // MARK: - Shadow Functionality
	@IBInspectable public var shadowRadius: Double = 0 {
		didSet { layer?.shadowRadius = CGFloat(shadowRadius) }
	}

	@IBInspectable public var shadowRadiusActive: Double = -1 {
		didSet {
			if state == .on {
				layer?.shadowRadius = CGFloat(shadowRadiusActive)
			}
		}
	}

	@IBInspectable public var shadowOpacity: Double = 0 {
		didSet { layer?.shadowOpacity = Float(shadowOpacity) }
	}

	@IBInspectable public var shadowActive: Double = -1 {
		didSet {
			if state == .on {
				layer?.shadowOpacity = Float(shadowActive)
			}
		}
	}

    @IBInspectable public var shadowColorLight: NSColor = .clear
    @IBInspectable public var shadowColorDark: NSColor = .clear
	@IBInspectable public var shadowColor: NSColor = .clear {
		didSet {
            shadowColorLight = shadowColor
            shadowColorDark = shadowColor
		}
	}
    
    @IBInspectable public var shadowColorLightActive: NSColor = .clear
    @IBInspectable public var shadowColorDarkActive: NSColor = .clear
	@IBInspectable public var shadowColorActive: NSColor = .clear {
		didSet {
            shadowColorLightActive = shadowColorActive
            shadowColorDarkActive = shadowColorActive
		}
	}
    
    private func getShadowColor() -> NSColor {
        if isLightAppearanc {
            return isOn || isPressed ? shadowColorLightActive : shadowColorLight
        } else {
            return isOn || isPressed ? shadowColorDarkActive : shadowColorDark
        }
    }
    
    
    // MARK: - Animation Functionality
    @IBInspectable public var animateState: Bool = true
    @IBInspectable public var animationDuration: Double = 0.01
    @IBInspectable public var activeAnimationDuration: Double = 0.2
    
    private func getAnimationDuration() -> Double {
        if !animateState { return 0 }
        return isOn ? activeAnimationDuration : animationDuration
    }
    
    
    // MARK: - Positioning
    public var contentPosition: ContentPosition = .center
    
    override open var intrinsicContentSize: NSSize {
        get {
            let textSize = calculateTitleArea()
            let iconSize = calculateIconArea()
            return NSSize(width: textSize.width + iconSize.width, height: max(textSize.height, iconSize.height))
        }
    }
    
    private func calculateTitleArea() -> NSSize {
        if title == "" { return NSSize() }
        
        var size = title.size(withAttributes: [.font: font as Any])
        size.width += titleMargin * 2
        
        return size
    }
    
    private func calculateIconArea() -> NSSize {
        guard let icon = icon else { return NSSize() }
        
        var size = icon.size
        size.width += title == "" && contentPosition == .center ? iconMargin * 2 : iconMargin
        
        return size
    }

    private func positionContent() {
        let hasTitle = title != ""
        let titleArea = calculateTitleArea()
        let titleY = (bounds.height - titleArea.height) / 2
        var titleX = CGFloat(0)
        
        let hasIcon = icon != nil
        let iconArea = calculateIconArea()
        let iconSize = icon?.size ?? NSSize()
        let iconY = (bounds.height - iconArea.height) / 2
        var iconX = CGFloat(0)
        
        if hasTitle {
            switch contentPosition {
                case .left:
                    titleX = 0
                case .right:
                    titleX = bounds.width - titleArea.width
                case .center:
                    titleX = titleArea.centered(in: bounds).origin.x
            }
        }
        
        if hasIcon {
            switch contentPosition {
                case .left:
                    iconX = iconMargin
                case .right:
                    iconX = bounds.width - iconArea.width
                case .center:
                    iconX = iconSize.centered(in: bounds).origin.x
            }
            
            // shift elements when both, icon and text exist
            if hasTitle {
                switch contentPosition {
                    case .left:
                        titleX += iconArea.width
                    case .right:
                        titleX -= iconArea.width
                    case .center:
                        titleX += iconArea.width / 2
                        iconX = titleX - iconSize.width
                        
                }
            }
        }
        
        titleLayer.frame = CGRect(x: titleX, y: titleY, width: titleArea.width, height: titleArea.height).roundedOrigin()
        iconLayer.frame = CGRect(x: iconX, y: iconY, width: iconSize.width, height: iconSize.height).roundedOrigin()
        iconMaskLayer.frame = iconLayer.bounds
    }
    
    // MARK: - Layout Functionality
    override open var wantsUpdateLayer: Bool { true }

	// Ensure the button doesn't draw its default contents.
	override open func draw(_ dirtyRect: CGRect) {}
	override open func drawFocusRingMask() {}

	override open func layout() {
		super.layout()
		positionContent()
	}

	override open func viewDidChangeBackingProperties() {
		super.viewDidChangeBackingProperties()
        
		if let scale = window?.backingScaleFactor {
			layer?.contentsScale = scale
			titleLayer.contentsScale = scale
            iconLayer.contentsScale = scale
            iconMaskLayer.contents = icon?.layerContents(forContentsScale: scale)
		}
	}

	public func setup() {
		wantsLayer = true

		layer?.masksToBounds = false
        layer?.autoresizingMask = .layerWidthSizable
        
		layer?.cornerRadius = CGFloat(cornerRadius)
		layer?.borderWidth = CGFloat(borderWidth)
		layer?.shadowRadius = CGFloat(isOn && shadowRadiusActive != -1 ? shadowRadiusActive : shadowRadius)
		layer?.shadowOpacity = Float(isOn && shadowActive != -1 ? shadowActive : shadowOpacity)
        layer?.backgroundColor = getBackgroundColor().cgColor
		layer?.borderColor = getBorderColor().cgColor
		layer?.shadowColor = getShadowColor().cgColor

		if #available(macOS 10.15, *) {
			layer?.cornerCurve = hasContinuousCorners ? .continuous : .circular
		}

        titleLayer.string = ""
		titleLayer.alignmentMode = .center
        titleLayer.contentsScale = window?.backingScaleFactor ?? 2
        titleLayer.foregroundColor = getTitleColor().cgColor
		layer?.addSublayer(titleLayer)
		setTitle()
        
        iconLayer.contentsScale = window?.backingScaleFactor ?? 2
        iconLayer.mask = iconMaskLayer
        layer?.addSublayer(iconLayer)
        setIcon()

        positionContent()
		needsDisplay = true
	}

	override open func updateLayer() {
		animateColor()
	}

	private func animateColor() {
        if !animateState {
            layer?.backgroundColor = getBackgroundColor().cgColor
            layer?.borderColor = getBorderColor().cgColor
            layer?.shadowColor = getShadowColor().cgColor
            titleLayer.foregroundColor = getTitleColor().cgColor
            iconLayer.backgroundColor = getTitleColor().cgColor
            return
        }
        /*
        let duration = getAnimationDuration()
		layer?.animate(\.backgroundColor, to: getBackgroundColor(), duration: duration)
		layer?.animate(\.borderColor, to: getBorderColor(), duration: duration)
		layer?.animate(\.shadowColor, to: getShadowColor(), duration: duration)
		titleLayer.animate(\.foregroundColor, to: getTitleColor(), duration: duration)
        iconLayer.animate(\.backgroundColor, to: getTitleColor(), duration: duration)
 */
	}
    
    
    // MARK: - Interaction Functionality
    private var isMouseDown = false

    private lazy var trackingArea = TrackingArea(
        for: self,
        options: [
            .mouseEnteredAndExited,
            .activeInActiveApp
        ]
    )

    override open func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingArea.update()
    }
    
	override open func hitTest(_ point: CGPoint) -> NSView? {
		isEnabled ? super.hitTest(point) : nil
	}

	override open func mouseDown(with event: NSEvent) {
        isPressed = true
	}

	override open func mouseEntered(with event: NSEvent) {
        isPressed = true
	}

	override open func mouseExited(with event: NSEvent) {
        isPressed = false
	}

	override open func mouseUp(with event: NSEvent) {
        isPressed = false
        toggleState()
        _ = target?.perform(action, with: self)
	}
    
    
    // MARK: - Constructors
    public convenience init() {
        self.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
}

extension CustomButton: NSViewLayerContentScaleDelegate {
	public func layer(_ layer: CALayer, shouldInheritContentsScale newScale: CGFloat, from window: NSWindow) -> Bool { true }
}

public enum ContentPosition {
    case left, center, right
}

