import Cocoa

@IBDesignable
open class CustomButton: NSButton {

	public static func circularButton(title: String, radius: Double, center: CGPoint) -> CustomButton {
		with(CustomButton()) {
			$0.title = title
			$0.frame = CGRect(x: Double(center.x) - radius, y: Double(center.y) - radius, width: radius * 2, height: radius * 2)
			$0.cornerRadius = radius
			$0.font = .systemFont(ofSize: CGFloat(radius * 2 / 3))
		}
	}
    
    
    // MARK: - State Functionality
    override public var isEnabled: Bool {
        didSet {
            alphaValue = isEnabled ? 1 : 0.6
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
    
    @IBInspectable public var textMargin: CGFloat = 8
    @IBInspectable public var textPosition: NSTextAlignment = .center

	@IBInspectable public var textColorLight: NSColor = .labelColor
    @IBInspectable public var textColorDark: NSColor = .labelColor
	@IBInspectable public var activeTextColorLight: NSColor = .labelColor
    @IBInspectable public var activeTextColorDark: NSColor = .labelColor
    
    @IBInspectable public var activeTextColor: NSColor = .clear {
        didSet {
            activeTextColorDark = activeTextColor
            activeTextColorLight = activeTextColor
        }
    }
    
    @IBInspectable public var textColor: NSColor = .clear {
        didSet {
            textColorDark = textColor
            textColorLight = textColor
        }
    }
    
    private func getTextColor() -> NSColor {
        if isLightAppearanc {
            return isOn ? activeTextColorLight : textColorLight
        } else {
            return isOn ? activeTextColorDark : textColorDark
        }
    }
    
    @IBInspectable override public var title: String {
        didSet {
            setTitle()
        }
    }
    
    override public var font: NSFont? {
        didSet {
            setTitle()
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
    
    
    // MARK: - Image Functionality
    private let imageLayer = CALayer()
    private let imageMaskLayer = CALayer()
    
    @IBInspectable public var imageMargin: CGFloat = 8
        
    @IBInspectable override public var image: NSImage? {
        didSet {
            setImage()
        }
    }
    
    private func setImage() {
        guard let image = image else { return }
        imageMaskLayer.contents = image.layerContents(forContentsScale: window?.backingScaleFactor ?? 2)
        needsLayout = true
    }
    
    
    // MARK: - Background Functionality
    @IBInspectable public var backgroundColorLight: NSColor = .clear
    @IBInspectable public var backgroundColorDark: NSColor = .clear
    @IBInspectable public var activeBackgroundColorLight: NSColor? = .clear
    @IBInspectable public var activeBackgroundColorDark: NSColor? = .clear

    @IBInspectable public var backgroundColor: NSColor = .clear {
        didSet {
            backgroundColorLight = backgroundColor
            backgroundColorDark = backgroundColor
        }
    }
    
    @IBInspectable public var activeBackgroundColor: NSColor = .clear {
        didSet {
            activeBackgroundColorLight = activeBackgroundColor
            activeBackgroundColorDark = activeBackgroundColor
        }
    }
    
    private func getBackgroundColor() -> NSColor {
        if isLightAppearanc {
            return isOn ? (activeBackgroundColorLight ?? backgroundColorLight) : backgroundColorLight
        } else {
            return isOn ? (activeBackgroundColorDark ?? backgroundColorDark) : backgroundColorDark
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
		didSet {
			layer?.cornerRadius = CGFloat(cornerRadius)
		}
	}

	@IBInspectable public var hasContinuousCorners: Bool = true {
		didSet {
			if #available(macOS 10.15, *) {
				layer?.cornerCurve = hasContinuousCorners ? .continuous : .circular
			}
		}
	}

	@IBInspectable public var borderWidth: Double = 0 {
		didSet {
			layer?.borderWidth = CGFloat(borderWidth)
		}
	}

    @IBInspectable public var borderColorLight: NSColor = .clear
    @IBInspectable public var borderColorDark: NSColor = .clear
    @IBInspectable public var activeBorderColorLight: NSColor = .clear
    @IBInspectable public var activeBorderColorDark: NSColor = .clear
    
	@IBInspectable public var borderColor: NSColor = .clear {
		didSet {
            borderColorLight = borderColor
            borderColorDark = borderColor
		}
	}

	@IBInspectable public var activeBorderColor: NSColor = .clear {
		didSet {
            activeBorderColorLight = activeBorderColor
            activeBorderColorDark = activeBorderColor
		}
	}
    
    private func getBorderColor() -> NSColor {
        if isLightAppearanc {
            return isOn ? activeBorderColorLight : borderColorLight
        } else {
            return isOn ? activeBorderColorDark : borderColorDark
        }
    }
    
    
    // MARK: - Shadow Functionality
	@IBInspectable public var shadowRadius: Double = 0 {
		didSet {
			layer?.shadowRadius = CGFloat(shadowRadius)
		}
	}

	@IBInspectable public var activeShadowRadius: Double = -1 {
		didSet {
			if state == .on {
				layer?.shadowRadius = CGFloat(activeShadowRadius)
			}
		}
	}

	@IBInspectable public var shadowOpacity: Double = 0 {
		didSet {
			layer?.shadowOpacity = Float(shadowOpacity)
		}
	}

	@IBInspectable public var activeShadowOpacity: Double = -1 {
		didSet {
			if state == .on {
				layer?.shadowOpacity = Float(activeShadowOpacity)
			}
		}
	}

    @IBInspectable public var shadowColorLight: NSColor = .clear
    @IBInspectable public var shadowColorDark: NSColor = .clear
    @IBInspectable public var activeShadowColorLight: NSColor = .clear
    @IBInspectable public var activeShadowColorDark: NSColor = .clear
    
	@IBInspectable public var shadowColor: NSColor = .clear {
		didSet {
            shadowColorLight = shadowColor
            shadowColorDark = shadowColor
		}
	}

	@IBInspectable public var activeShadowColor: NSColor = .clear {
		didSet {
            activeShadowColorLight = activeShadowColor
            activeShadowColorDark = activeShadowColor
		}
	}
    
    private func getShadowColor() -> NSColor {
        if isLightAppearanc {
            return isOn ? activeShadowColorLight : shadowColorLight
        } else {
            return isOn ? activeShadowColorDark : shadowColorDark
        }
    }
    
    
    // MARK: - Animation Functionality
    @IBInspectable public var animateState: Bool = true
    @IBInspectable public var animationDuration: Double = 0.01
    @IBInspectable public var activeAnimationDuration: Double = 0.2
    
    private func getAnimationDuration() -> Double {
        return isOn ? activeAnimationDuration : animationDuration
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

    private func positionContent() {
        let titleSize = title.size(withAttributes: [.font: font as Any])
        titleLayer.frame = titleSize.centered(in: bounds);
        
        if textPosition == .left { titleLayer.frame.origin.x = textMargin }
        if textPosition == .right { titleLayer.frame.origin.x = bounds.width - titleLayer.frame.width - textMargin }
        
        if let image = image {
            let imageWidth = image.size.width
            let imageWidthMargin = imageWidth + imageMargin
            
            imageLayer.frame.size = image.size
            if textPosition == .left {
                titleLayer.frame.origin.x += imageWidthMargin
                imageLayer.frame.origin.x = imageMargin
            } else if textPosition == .right {
                titleLayer.frame.origin.x -= imageWidthMargin
                imageLayer.frame.origin.x = bounds.width - imageWidthMargin
            } else {
                titleLayer.frame.origin.x += (imageWidth + textMargin) / 2
                imageLayer.frame.origin.x = titleLayer.frame.origin.x - textMargin - imageWidth
            }
            imageLayer.frame.origin.y = (bounds.height - imageLayer.frame.height) / 2
            imageMaskLayer.frame = imageLayer.bounds
        } else {
            imageLayer.isHidden = true
        }
    }

	override open func viewDidChangeBackingProperties() {
		super.viewDidChangeBackingProperties()
        
		if let scale = window?.backingScaleFactor {
			layer?.contentsScale = scale
			titleLayer.contentsScale = scale
            imageLayer.contentsScale = scale
            imageMaskLayer.contents = image?.layerContents(forContentsScale: scale)
		}
	}

	public func setup() {
		wantsLayer = true

		layer?.masksToBounds = false
        
		layer?.cornerRadius = CGFloat(cornerRadius)
		layer?.borderWidth = CGFloat(borderWidth)
		layer?.shadowRadius = CGFloat(isOn && activeShadowRadius != -1 ? activeShadowRadius : shadowRadius)
		layer?.shadowOpacity = Float(isOn && activeShadowOpacity != -1 ? activeShadowOpacity : shadowOpacity)
        layer?.backgroundColor = getBackgroundColor().cgColor
		layer?.borderColor = getBorderColor().cgColor
		layer?.shadowColor = getShadowColor().cgColor

		if #available(macOS 10.15, *) {
			layer?.cornerCurve = hasContinuousCorners ? .continuous : .circular
		}

		titleLayer.alignmentMode = .center
		titleLayer.contentsScale = window?.backingScaleFactor ?? 2
        titleLayer.foregroundColor = getTextColor().cgColor
		layer?.addSublayer(titleLayer)
		setTitle()
        
        imageLayer.contentsScale = window?.backingScaleFactor ?? 2
        imageLayer.backgroundColor = isOn ? activeTextColor.cgColor : textColor.cgColor
        imageLayer.mask = imageMaskLayer
        layer?.addSublayer(imageLayer)
        setImage()

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
            titleLayer.foregroundColor = getTextColor().cgColor
            return
        }
        
        let duration = getAnimationDuration()
		layer?.animate(\.backgroundColor, to: getBackgroundColor(), duration: duration)
		layer?.animate(\.borderColor, to: getBorderColor(), duration: duration)
		layer?.animate(\.shadowColor, to: getShadowColor(), duration: duration)
		titleLayer.animate(\.foregroundColor, to: getTextColor(), duration: duration)
        imageLayer.animate(\.backgroundColor, to: getTextColor(), duration: duration)
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
		isMouseDown = true
		toggleState()
	}

	override open func mouseEntered(with event: NSEvent) {
		if isMouseDown {
			toggleState()
		}
	}

	override open func mouseExited(with event: NSEvent) {
		if isMouseDown {
			toggleState()
			isMouseDown = false
		}
	}

	override open func mouseUp(with event: NSEvent) {
		if isMouseDown {
			isMouseDown = false
			toggleState()
			_ = target?.perform(action, with: self)
		}
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
