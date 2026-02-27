import SwiftUI
import AVFoundation
import AppKit

struct CameraPreviewView: View {
    @ObservedObject var cameraManager: CameraManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let _ = cameraManager.previewLayer {
                    CameraLayerView(cameraManager: cameraManager)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                } else if let error = cameraManager.errorMessage {
                    errorView(message: error, size: geometry.size)
                } else {
                    loadingView(size: geometry.size)
                }
            }
        }
        .background(Color.clear)
    }
    
    private func loadingView(size: CGSize) -> some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.black.opacity(0.8))
            .frame(width: size.width, height: size.height)
            .overlay(
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            )
    }
    
    private func errorView(message: String, size: CGSize) -> some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.black.opacity(0.9))
            .frame(width: size.width, height: size.height)
            .overlay(
                VStack(spacing: 12) {
                    Image(systemName: "video.slash")
                        .font(.system(size: 32))
                        .foregroundColor(.red)
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
            )
    }
}

struct CameraLayerView: NSViewRepresentable {
    @ObservedObject var cameraManager: CameraManager
    
    func makeNSView(context: Context) -> CameraContainerView {
        let view = CameraContainerView()
        view.wantsLayer = true
        return view
    }
    
    func updateNSView(_ nsView: CameraContainerView, context: Context) {
        if let previewLayer = cameraManager.previewLayer {
            nsView.setPreviewLayer(previewLayer)
        }
    }
}

class CameraContainerView: NSView {
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.cornerRadius = 16
        layer?.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPreviewLayer(_ layer: AVCaptureVideoPreviewLayer) {
        // Remove existing layer if different
        if previewLayer !== layer {
            previewLayer?.removeFromSuperlayer()
            previewLayer = layer
            layer.cornerRadius = 16
            layer.masksToBounds = true
            self.layer?.addSublayer(layer)
        }
        
        // Update frame
        layer.frame = bounds
    }
    
    override func layout() {
        super.layout()
        previewLayer?.frame = bounds
    }
}
