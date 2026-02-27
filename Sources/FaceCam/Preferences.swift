import Foundation
import AppKit

class Preferences {
    static let shared = Preferences()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let windowX = "windowX"
        static let windowY = "windowY"
        static let windowSize = "windowSize"
        static let windowVisible = "windowVisible"
    }
    
    private init() {}
    
    var windowX: CGFloat {
        get {
            if defaults.object(forKey: Keys.windowX) != nil {
                return CGFloat(defaults.double(forKey: Keys.windowX))
            }
            // Default: bottom-right corner
            return defaultPosition.x
        }
        set {
            defaults.set(Double(newValue), forKey: Keys.windowX)
        }
    }
    
    var windowY: CGFloat {
        get {
            if defaults.object(forKey: Keys.windowY) != nil {
                return CGFloat(defaults.double(forKey: Keys.windowY))
            }
            // Default: bottom-right corner
            return defaultPosition.y
        }
        set {
            defaults.set(Double(newValue), forKey: Keys.windowY)
        }
    }
    
    var windowSize: CGFloat {
        get {
            let size = CGFloat(defaults.double(forKey: Keys.windowSize))
            return size > 0 ? size : 300 // Default size
        }
        set {
            defaults.set(Double(newValue), forKey: Keys.windowSize)
        }
    }
    
    var windowVisible: Bool {
        get { defaults.bool(forKey: Keys.windowVisible) }
        set { defaults.set(newValue, forKey: Keys.windowVisible) }
    }
    
    // Calculate default position (bottom-right with margin)
    private var defaultPosition: NSPoint {
        guard let screen = NSScreen.main else {
            return NSPoint(x: 100, y: 100)
        }
        
        let margin: CGFloat = 20
        let size = windowSize
        let visibleFrame = screen.visibleFrame
        
        return NSPoint(
            x: visibleFrame.maxX - size - margin,
            y: visibleFrame.minY + margin
        )
    }
    
    func resetToDefaults() {
        defaults.removeObject(forKey: Keys.windowX)
        defaults.removeObject(forKey: Keys.windowY)
        defaults.removeObject(forKey: Keys.windowSize)
        defaults.removeObject(forKey: Keys.windowVisible)
    }
}
