import SwiftUI

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}


struct FrameViewWidget: View {
    @StateObject private var model = FrameHandler()
    @State private var showOptions = false
    @State private var orientation = UIDevice.current.orientation

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("📷 Camera Frame")
                    .font(.headline)
                    .bold()
                Spacer()
                Menu {
                    Section(header: Text("Switch Camera")) {
                        ForEach(model.availableDevices, id: \.uniqueID) { device in
                            Button(device.localizedName) {
                                model.switchCamera(to: device)
                            }
                        }
                    }
                    Section(header: Text("Zoom")) {
                        Button("1x") { model.updateZoom(to: 1.0) }
                        Button("2x") { model.updateZoom(to: 2.0) }
                        Button("4x") { model.updateZoom(to: 4.0) }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                        .padding(.trailing, 4)
                }
            }

            GeometryReader { geometry in
                CameraPreviewView(session: model.session, orientation: orientation)
                    .frame(width: geometry.size.width, height: geometry.size.width * 3 / 4)
                    .cornerRadius(12)
                    .clipped()
            }
            .frame(height: 200)
        }
        .padding()
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
