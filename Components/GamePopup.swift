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
    
    @State private var currentGameType: GameType = .bubblePop

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
                        Text(currentGameType.title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.primary, .primary.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text(currentGameType.instruction)
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

                        gameContentView(gameWidth: gameWidth, gameHeight: gameHeight)
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
            currentGameType = GameType.random()
            isActive = true
            
            if currentGameType == .bubblePop {
                spawnBubbles()
            }
        }
    }
    
    @ViewBuilder
    func gameContentView(gameWidth: CGFloat, gameHeight: CGFloat) -> some View {
        switch currentGameType {
        case .bubblePop:
            bubblePopGame(gameWidth: gameWidth, gameHeight: gameHeight)
            
        case .colorMatch:
            ColorMatchGameView(
                score: $score,
                isActive: $isActive,
                onComplete: onDismiss,
                containerWidth: gameWidth,
                containerHeight: gameHeight
            )
            
        case .tapRace:
            TapRaceGameView(
                score: $score,
                isActive: $isActive,
                onComplete: onDismiss,
                containerWidth: gameWidth,
                containerHeight: gameHeight
            )
        }
    }
    
    @ViewBuilder
    func bubblePopGame(gameWidth: CGFloat, gameHeight: CGFloat) -> some View {
        ZStack {
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
    }

    func spawnBubbles() {
        let colors: [Color] = [.blue, .cyan, .purple, .pink, .green, .orange]
        let bubbleSize: CGFloat = 60
        let columns: CGFloat = 3
        let rows: CGFloat = 2

        for i in 0..<6 {
            let col = i % Int(columns)
            let row = i / Int(columns)

            let normalizedX = CGFloat(col + 1) / (columns + 1)
            let normalizedY = CGFloat(row + 1) / (rows + 1)

            let randomOffsetX = CGFloat.random(in: -0.08...0.08)
            let randomOffsetY = CGFloat.random(in: -0.08...0.08)

            let finalNormalizedX = max(0.1, min(0.9, normalizedX + randomOffsetX))
            let finalNormalizedY = max(0.1, min(0.9, normalizedY + randomOffsetY))

            let bubble = Bubble(
                position: CGPoint(x: finalNormalizedX, y: finalNormalizedY),
                size: bubbleSize,
                color: colors[i % colors.count]
            )

            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.15) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    bubbles.append(bubble)
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 6.0 + Double(i) * 0.15) {
                withAnimation(.easeOut(duration: 0.3)) {
                    bubbles.removeAll { $0.id == bubble.id }
                }
            }
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
