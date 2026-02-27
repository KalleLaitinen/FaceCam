import AppKit

class FloatingWindow: NSWindow {
    var onFrameChange: ((NSRect) -> Void)?
    
    private let minimumWindowSize: CGFloat = 150
    private let maximumWindowSize: CGFloat = 800
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        configure()
    }
    
    private func configure() {
        // Floating window level (above normal windows)
        level = .floating
        
        // Transparent background
        backgroundColor = .clear
        isOpaque = false
        hasShadow = true
        
        // Allow dragging from anywhere
        isMovableByWindowBackground = true
        
        // Collection behavior
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        // Aspect ratio (1:1 square)
        aspectRatio = NSSize(width: 1, height: 1)
        
        // Size constraints
        minSize = NSSize(width: minimumWindowSize, height: minimumWindowSize)
        maxSize = NSSize(width: maximumWindowSize, height: maximumWindowSize)
        
        // Track frame changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidMove),
            name: NSWindow.didMoveNotification,
            object: self
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidResize),
            name: NSWindow.didResizeNotification,
            object: self
        )
    }
    
    @objc private func windowDidMove(_ notification: Notification) {
        onFrameChange?(frame)
    }
    
    @objc private func windowDidResize(_ notification: Notification) {
        onFrameChange?(frame)
    }
    
    // Allow the window to become key for interactions
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
