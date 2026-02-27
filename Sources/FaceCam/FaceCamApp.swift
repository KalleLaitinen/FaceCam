import SwiftUI
import AppKit

@main
struct FaceCamApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var cameraWindow: FloatingWindow?
    private var cameraManager = CameraManager()
    private let preferences = Preferences.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        
        // Restore window state if it was visible
        if preferences.windowVisible {
            showCameraWindow()
        }
    }
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            // Use a mirror-like icon (person in viewfinder works well)
            if let image = NSImage(systemSymbolName: "person.crop.rectangle", accessibilityDescription: "FaceCam") {
                image.isTemplate = true
                button.image = image
            } else {
                button.title = "🪞"
            }
        }
        
        let menu = NSMenu()
        
        let showItem = NSMenuItem(title: "Show Mirror", action: #selector(toggleWindow), keyEquivalent: "")
        showItem.target = self
        menu.addItem(showItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit FaceCam", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    @objc private func toggleWindow() {
        if let window = cameraWindow, window.isVisible {
            hideCameraWindow()
        } else {
            showCameraWindow()
        }
        updateMenuState()
    }
    
    private func showCameraWindow() {
        if cameraWindow == nil {
            createCameraWindow()
        }
        
        cameraWindow?.makeKeyAndOrderFront(nil)
        cameraManager.startCapture()
        preferences.windowVisible = true
        updateMenuState()
    }
    
    private func hideCameraWindow() {
        cameraWindow?.orderOut(nil)
        cameraManager.stopCapture()
        preferences.windowVisible = false
        updateMenuState()
    }
    
    private func createCameraWindow() {
        let size = preferences.windowSize
        let frame = NSRect(
            x: preferences.windowX,
            y: preferences.windowY,
            width: size,
            height: size
        )
        
        cameraWindow = FloatingWindow(
            contentRect: frame,
            styleMask: [.borderless, .resizable],
            backing: .buffered,
            defer: false
        )
        
        cameraWindow?.onFrameChange = { [weak self] frame in
            self?.preferences.windowX = frame.origin.x
            self?.preferences.windowY = frame.origin.y
            self?.preferences.windowSize = frame.width
        }
        
        let contentView = CameraPreviewView(cameraManager: cameraManager)
        cameraWindow?.contentView = NSHostingView(rootView: contentView)
    }
    
    private func updateMenuState() {
        if let menu = statusItem.menu, let showItem = menu.items.first {
            let isVisible = cameraWindow?.isVisible ?? false
            showItem.title = isVisible ? "Hide Mirror" : "Show Mirror"
            showItem.state = isVisible ? .on : .off
        }
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
