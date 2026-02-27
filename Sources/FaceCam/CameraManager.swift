import AVFoundation
import AppKit

class CameraManager: NSObject, ObservableObject {
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    @Published var isAuthorized = false
    @Published var errorMessage: String?
    
    private var captureSession: AVCaptureSession?
    private let sessionQueue = DispatchQueue(label: "com.facecam.session")
    
    override init() {
        super.init()
        checkAuthorization()
    }
    
    private func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
                    if granted {
                        self?.setupSession()
                    } else {
                        self?.errorMessage = "Camera access denied"
                    }
                }
            }
        case .denied, .restricted:
            isAuthorized = false
            errorMessage = "Camera access denied. Enable in System Settings > Privacy > Camera"
        @unknown default:
            errorMessage = "Unknown camera authorization status"
        }
    }
    
    private func setupSession() {
        sessionQueue.async { [weak self] in
            self?.configureSession()
        }
    }
    
    private func configureSession() {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        
        // Find front camera
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
                ?? AVCaptureDevice.default(for: .video) else {
            DispatchQueue.main.async {
                self.errorMessage = "No camera found"
            }
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer.videoGravity = .resizeAspectFill
            
            // Mirror the video (like a real mirror)
            layer.transform = CATransform3DMakeScale(-1, 1, 1)
            
            DispatchQueue.main.async {
                self.captureSession = session
                self.previewLayer = layer
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to setup camera: \(error.localizedDescription)"
            }
        }
    }
    
    func startCapture() {
        sessionQueue.async { [weak self] in
            if self?.captureSession?.isRunning == false {
                self?.captureSession?.startRunning()
            }
        }
    }
    
    func stopCapture() {
        sessionQueue.async { [weak self] in
            if self?.captureSession?.isRunning == true {
                self?.captureSession?.stopRunning()
            }
        }
    }
}
