//
//  PrimaryButton.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String

    @State private var isPressed = false

    private let fillColor = Color(hex: "#FFBD59")
    private let borderColor = Color(hex: "#E39A2D")

    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(width: 300, height: 64)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(fillColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(borderColor, lineWidth: 4)
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.12), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

#Preview {
    PrimaryButton(title: "Preview Button")
}
