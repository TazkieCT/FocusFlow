//
//  VideoGameplayView.swift
//  Focus Flow
//
//  Created by Hush on 20/11/25.
//

import SwiftUI
import AVKit
import Combine

struct VideoGameplayView: View {
    let taskTitle: String
    let videoFileName: String

    @StateObject private var videoManager = VideoManager()
    @Environment(\.dismiss) var dismiss

    @State private var bubbles: [Bubble] = []
    @State private var score: Int = 0
    @State private var gameActive: Bool = false
    @State private var showGamePopup: Bool = false
    @State private var navigateToCompletion = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if !showGamePopup {
                VStack(spacing: 20) {
                    if videoManager.isLoading {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(16/9, contentMode: .fit)
                            .overlay(
                                VStack(spacing: 20) {
                                    ProgressView().scaleEffect(1.5).tint(.white)
                                    Text("Loading video...").foregroundColor(.white)
                                }
                            )
                    } else if let player = videoManager.player {
                        VideoPlayer(player: player)
                            .aspectRatio(16/9, contentMode: .fit)
                            .cornerRadius(16)
                            .disabled(true)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.2))
                            .aspectRatio(16/9, contentMode: .fit)
                            .overlay(
                                VStack(spacing: 20) {
                                    Image(systemName: "video.slash")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white)
                                    Text("Video not available")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)
                                    Text("Continuing to completion...")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                    ProgressView()
                                        .scaleEffect(1.2)
                                        .tint(.white)
                                        .padding(.top, 10)
                                }
                            )
                    }

                    Spacer()
                }
                .padding(.horizontal, 40)
            }

            if showGamePopup {
                GamePopup(
                    bubbles: $bubbles,
                    score: $score,
                    isActive: $gameActive,
                    onDismiss: {
                        showGamePopup = false
                        gameActive = false
                    }
                )
            }
        }
        .navigationTitle(taskTitle)
        .overlay(
            Text("Score: \(score)")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .padding(.trailing, 20)
                .padding(.top, 50)
            ,alignment: .topTrailing
        )
        .onAppear {
            videoManager.loadVideo(named: videoFileName)
            videoManager.onVideoEnd = { endGame() }
            setupGamePopupTimer()
        }
        .onDisappear {
            videoManager.cleanup()
        }
        .fullScreenCover(isPresented: $navigateToCompletion) {
            CompletionView(
                taskTitle: taskTitle,
                score: score,
                coinsEarned: score * 2,
                isTaskComplete: true
            )
        }
    }

    func setupGamePopupTimer() {
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            if !showGamePopup {
                showGamePopup = true
                gameActive = true
                spawnBubbles()
            }
        }
    }

    func spawnBubbles() {
        let colors: [Color] = [.blue, .cyan, .purple, .pink, .green, .orange]
        let containerWidth: CGFloat = 600
        let containerHeight: CGFloat = 300
        let bubbleSize: CGFloat = 60
        let columns: CGFloat = 3
        let rows: CGFloat = 2

        let xSpacing = containerWidth / (columns + 1)
        let ySpacing = containerHeight / (rows + 1)

        for i in 0..<6 {
            let col = i % Int(columns)
            let row = i / Int(columns)

            let centerX = xSpacing * CGFloat(col + 1)
            let centerY = ySpacing * CGFloat(row + 1)

            let randomOffsetX = CGFloat.random(in: -40...40)
            let randomOffsetY = CGFloat.random(in: -30...30)

            let finalX = max(bubbleSize/2, min(containerWidth - bubbleSize/2, centerX + randomOffsetX))
            let finalY = max(bubbleSize/2, min(containerHeight - bubbleSize/2, centerY + randomOffsetY))

            let bubble = Bubble(
                position: CGPoint(x: finalX, y: finalY),
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

    func endGame() {
        navigateToCompletion = true
    }
}

struct GamePopup: View {
    @Binding var bubbles: [Bubble]
    @Binding var score: Int
    @Binding var isActive: Bool
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 15) {
                    Text("Bubble Time!")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 2)
                        .padding(.horizontal, 100)
                }
                .padding(.top, 30)

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(width: 450, height: 250)

                    ForEach(bubbles) { bubble in
                        Button(action: { popBubble(bubble) }) {
                            Circle()
                                .fill(bubble.color)
                                .frame(width: bubble.size, height: bubble.size)
                                .overlay(
                                    Image(systemName: "sparkles")
                                        .font(.system(size: bubble.size * 0.3))
                                        .foregroundColor(.white.opacity(0.9))
                                )
                                .shadow(color: bubble.color.opacity(0.4), radius: 3, x: 0, y: 1)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .position(
                            x: min(max(bubble.size/2, bubble.position.x), 450 - bubble.size/2),
                            y: min(max(bubble.size/2, bubble.position.y), 250 - bubble.size/2)
                        )
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 25)

                Spacer()
                    .frame(height: 20)

                if bubbles.isEmpty {
                    Button(action: {
                        spawnNewBubbles()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 14, weight: .bold))
                            Text("Play Again")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 160, height: 45)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(12)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 5)
            )
            .padding(.horizontal, 50)
            .padding(.vertical, 20)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onDismiss()
        }
        .onAppear {
            isActive = true
        }
    }

    func spawnNewBubbles() {
        let colors: [Color] = [.blue, .cyan, .purple, .pink, .green, .orange]
        let containerWidth: CGFloat = 500
        let containerHeight: CGFloat = 280
        let bubbleSize: CGFloat = 50
        let columns: CGFloat = 4
        let rows: CGFloat = 2

        let xSpacing = containerWidth / (columns + 1)
        let ySpacing = containerHeight / (rows + 1)

        for i in 0..<8 {
            let col = i % Int(columns)
            let row = i / Int(columns)

            let centerX = xSpacing * CGFloat(col + 1)
            let centerY = ySpacing * CGFloat(row + 1)

            let randomOffsetX = CGFloat.random(in: -30...30)
            let randomOffsetY = CGFloat.random(in: -20...20)

            let finalX = max(bubbleSize/2, min(containerWidth - bubbleSize/2, centerX + randomOffsetX))
            let finalY = max(bubbleSize/2, min(containerHeight - bubbleSize/2, centerY + randomOffsetY))

            let bubble = Bubble(
                position: CGPoint(x: finalX, y: finalY),
                size: bubbleSize,
                color: colors[i % colors.count]
            )

            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    bubbles.append(bubble)
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0 + Double(i) * 0.1) {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                onDismiss()
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGFloat
    let color: Color
}

class VideoManager: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isLoading: Bool = false

    var onVideoEnd: (() -> Void)?

    func loadVideo(named fileName: String) {
        isLoading = true

        if let videoURL = Bundle.main.url(forResource: fileName, withExtension: "mp4") {
            player = AVPlayer(url: videoURL)

            if !UserDefaults.standard.bool(forKey: "soundEnabled") {
                player?.isMuted = true
            }

            isLoading = false
            setupEndObserver()
            player?.play()
        } else {
            isLoading = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.onVideoEnd?()
            }
        }
    }

    func setupEndObserver() {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.onVideoEnd?()
        }
    }

    func updateSoundSettings() {
        player?.isMuted = !UserDefaults.standard.bool(forKey: "soundEnabled")
    }

    func cleanup() {
        player?.pause()
        player = nil
    }
}

#Preview {
    NavigationStack {
        VideoGameplayView(taskTitle: "Tooth Brushing", videoFileName: "ToothBrush")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
