import Foundation
import SwiftUI
import AVFoundation

class FrameHandler: NSObject, ObservableObject {
    let session = AVCaptureSession()
    @Published var availableDevices: [AVCaptureDevice] = []
    @Published var currentDevice: AVCaptureDevice?
    @Published var zoomFactor: CGFloat = 1.0
    @Published var isRecording: Bool = false  // ✅ Published for tracking

    override init() {
        super.init()
        setupSession()
    }

    func setupSession() {
        session.beginConfiguration()

        if let currentInput = session.inputs.first {
            session.removeInput(currentInput)
        }

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else { return }

        session.addInput(input)
        currentDevice = device
        availableDevices = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera, .builtInTelephotoCamera],
            mediaType: .video,
            position: .back
        ).devices

        session.commitConfiguration()
        session.startRunning()
    }

    func switchCamera(to device: AVCaptureDevice) {
        session.beginConfiguration()
        session.inputs.forEach { session.removeInput($0) }
        if let input = try? AVCaptureDeviceInput(device: device), session.canAddInput(input) {
            session.addInput(input)
            currentDevice = device
        }
        session.commitConfiguration()
    }

    func updateZoom(to factor: CGFloat) {
        guard let device = currentDevice else { return }
        try? device.lockForConfiguration()
        device.videoZoomFactor = min(max(factor, 1.0), device.activeFormat.videoMaxZoomFactor)
        device.unlockForConfiguration()
        zoomFactor = factor
    }

    func toggleRecording() {
        isRecording.toggle()  // ✅ Toggle published bool
    }
}
