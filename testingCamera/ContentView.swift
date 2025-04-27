import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var frameHandler = FrameHandler()

    var body: some View {
        let columns = horizontalSizeClass == .compact ? [GridItem(.flexible())] : [GridItem(.flexible()), GridItem(.flexible())]

        ZStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    WidgetContainer(defaultWidget: .altitudeTilt)
                    WidgetContainer(defaultWidget: .compass)
                }
                .padding()
            }

            VStack {
                HStack {
                    if frameHandler.isRecording {
                        Label("Recording", systemImage: "record.circle")
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .transition(.opacity)
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        frameHandler.toggleRecording()
                    }) {
                        Circle()
                            .fill(frameHandler.isRecording ? Color.red : Color.white)
                            .frame(width: 50, height: 50)
                            .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 1))
                            .shadow(radius: 4)
                            .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
