//
//  FrameView.swift
//  testingCamera
//
//  Created by Saad Bajwa on 4/25/25.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    private let label = Text("Frame")
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
        } else {
            Color.black
        }
    }
}

#Preview {
    FrameView()
}
