import SwiftUI

enum WidgetType: String, CaseIterable, Identifiable {
    case altitudeTilt = "Altitude & Tilt"
    case compass = "Compass"
    case pitch = "Pitch"
    case roll = "Roll"
    case camera = "Camera Frame"

    var id: String { rawValue }
}

struct WidgetContainer: View {
    @State private var selected: WidgetType
    @State private var showPicker = false
    @GestureState private var isPressing = false

    init(defaultWidget: WidgetType) {
        _selected = State(initialValue: defaultWidget)
    }

    var body: some View {
        ZStack {
            switch selected {
            case .altitudeTilt:
                AltitudeTiltView()
            case .compass:
                CompassView()
            case .pitch:
                PitchView()
            case .roll:
                RollView()
            case .camera:
                FrameViewWidget()
            }
        }
        .scaleEffect(isPressing ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressing)
        .gesture(
            LongPressGesture(minimumDuration: 0.4)
                .updating($isPressing) { currentState, gestureState, _ in
                    gestureState = currentState
                }
                .onEnded { _ in
                    showPicker = true
                }
        )
        .confirmationDialog("Select a widget", isPresented: $showPicker, titleVisibility: .visible) {
            ForEach(WidgetType.allCases) { type in
                Button(type.rawValue) {
                    selected = type
                }
            }
        } message: {
            Text("Choose a widget to display in this slot.")
        }
    }
}
