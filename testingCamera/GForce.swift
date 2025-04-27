//
//  GForce.swift
//  testingCamera
//
//  Created by Saad Bajwa on 4/26/25.
//

import SwiftUI

struct GForce: View {
    @StateObject private var motion = MotionManager()
    
    var body: some View {
        Text("📱 G-Force Meter")
                        .font(.largeTitle)
                        .bold()

                    Text(String(format: "X: %.2f", motion.x))
                    Text(String(format: "Y: %.2f", motion.y))
                    Text(String(format: "Z: %.2f", motion.z))

                    Divider().padding(.vertical)

                    Text(String(format: "G-Force: %.2f g", motion.gForce))
                        .font(.title)
                        .bold()
                        .foregroundColor(motion.gForce > 2.5 ? .red : .blue)

                    Spacer()

    }
}

#Preview {
    GForce()
}
