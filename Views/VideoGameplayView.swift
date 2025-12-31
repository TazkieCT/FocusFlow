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
    @State private var isFullscreen = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(white: 0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if !showGamePopup {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        VStack {
                            if videoManager.isLoading {
                                LoadingVideoView()
                            } else if let player = videoManager.player {
                                CustomVideoPlayer(
                                    player: player,
                                    isFullscreen: $isFullscreen,
                                    videoManager: videoManager
                                )
                                .aspectRatio(16/9, contentMode: .fit)
                                .cornerRadius(isFullscreen ? 0 : 20)
                                .shadow(color: .black.opacity(0.3), radius: isFullscreen ? 0 : 20, y: isFullscreen ? 0 : 10)
                            } else {
                                VideoUnavailableView()
                            }
                        }
                        .frame(maxWidth: isFullscreen ? geometry.size.width : geometry.size.width * 4)
                        .frame(maxHeight: isFullscreen ? geometry.size.height : geometry.size.height * 4)
                        
                        if !isFullscreen {
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
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
            
            if !isFullscreen && !showGamePopup {
                VStack {
                    HStack {
                        Spacer()
                        ScoreCard(score: score)
                    }
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.trailing, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isFullscreen {
                ToolbarItem(placement: .principal) {
                    Text(taskTitle)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
        }
        .statusBar(hidden: isFullscreen)
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

    func endGame() {
        navigateToCompletion = true
    }
}

#Preview {
    NavigationStack {
        VideoGameplayView(taskTitle: "Tooth Brushing", videoFileName: "ToothBrush")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
