//
//  GamePopup.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI

struct GamePopup: View {
    @Binding var bubbles: [Bubble]
    @Binding var score: Int
    @Binding var isActive: Bool
    let onDismiss: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        onDismiss()
                    }

                VStack(spacing: 0) {
                    VStack(spacing: 6) {
                        Text("Bubble Time!")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.primary, .primary.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Tap the bubbles!")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 15)

                    let gameWidth = min(geometry.size.width * 0.6, 450.0)
                    let gameHeight = min(geometry.size.height * 0.5, 300.0)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(white: 0.95),
                                        Color(white: 0.92)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .frame(width: gameWidth, height: gameHeight)

                        ForEach(bubbles) { bubble in
                            BubbleView(bubble: bubble, containerWidth: gameWidth, containerHeight: gameHeight) {
                                popBubble(bubble)
                            }
                        }
                        
                        if bubbles.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.green)
                                
                                Text("All bubbles popped!")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(height: gameHeight)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 35)
                }
                .frame(maxWidth: min(geometry.size.width * 0.8, 550))
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.ultraThickMaterial)
                        .shadow(color: .black.opacity(0.3), radius: 30, y: 15)
                )
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .onAppear {
            isActive = true
        }
    }

    func popBubble(_ bubble: Bubble) {
        if UserDefaults.standard.bool(forKey: "soundEnabled") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }

        withAnimation(.easeOut(duration: 0.3)) {
            bubbles.removeAll { $0.id == bubble.id }
        }
        score += 1

        if bubbles.isEmpty {
            if UserDefaults.standard.bool(forKey: "soundEnabled") {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onDismiss()
            }
        }
    }
}
