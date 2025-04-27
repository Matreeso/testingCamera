import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    let orientation: UIDeviceOrientation

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        context.coordinator.previewLayer = previewLayer
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let previewLayer = context.coordinator.previewLayer else { return }
        previewLayer.frame = uiView.bounds

        if let connection = previewLayer.connection, connection.isVideoOrientationSupported {
            connection.videoOrientation = orientationToAVOrientation(orientation)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }

    func orientationToAVOrientation(_ orientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        case .portraitUpsideDown: return .portraitUpsideDown
        default: return .portrait
        }
    }
}
