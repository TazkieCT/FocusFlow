//
//  CustomVideoPlayer.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI
import AVKit

struct CustomVideoPlayer: View {
    let player: AVPlayer
    @Binding var isFullscreen: Bool
    let videoManager: VideoManager
    
    @State private var isPlaying = true
    @State private var showControls = false
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    @State private var isSeeking = false
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .disabled(true)
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showControls.toggle()
                    }
                }
            
            if showControls {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 2) {
                        VStack(spacing: 4) {
                            HStack(spacing: 12) {
                                Text(timeString(from: currentTime))
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundColor(.white)
                                    .monospacedDigit()
                                
                                Slider(value: Binding(
                                    get: { currentTime },
                                    set: { newValue in
                                        currentTime = newValue
                                        isSeeking = true
                                    }
                                ), in: 0...max(duration, 0.1), onEditingChanged: { editing in
                                    if !editing {
                                        player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
                                        isSeeking = false
                                    }
                                })
                                .accentColor(.white)
                                
                                Text(timeString(from: duration))
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                    .monospacedDigit()
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        HStack(spacing: 30) {
                            Button(action: {
                                let newTime = max(currentTime - 10, 0)
                                player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
                            }) {
                                Image(systemName: "gobackward.10")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: {
                                if isPlaying {
                                    player.pause()
                                } else {
                                    player.play()
                                }
                                isPlaying.toggle()
                            }) {
                                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 50, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: {
                                let newTime = min(currentTime + 10, duration)
                                player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
                            }) {
                                Image(systemName: "goforward.10")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        HStack {
                            Button(action: {
                                player.isMuted.toggle()
                            }) {
                                Image(systemName: player.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isFullscreen.toggle()
                                }
                            }) {
                                Image(systemName: isFullscreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .background(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0),
                                Color.black.opacity(0.7),
                                Color.black.opacity(0.9)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .transition(.opacity)
            }
        }
        .onReceive(timer) { _ in
            if !isSeeking {
                currentTime = player.currentTime().seconds
                if let item = player.currentItem {
                    duration = item.duration.seconds
                    if duration.isNaN || duration.isInfinite {
                        duration = 0
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showControls = false
                }
            }
        }
    }
    
    func timeString(from seconds: Double) -> String {
        guard !seconds.isNaN && !seconds.isInfinite else { return "0:00" }
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
