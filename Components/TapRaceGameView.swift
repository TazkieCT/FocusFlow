//
//  TapRaceGameView.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 01/01/26.
//

import SwiftUI

struct TapRaceGameView: View {
    @Binding var score: Int
    @Binding var isActive: Bool
    let onComplete: () -> Void
    
    @State private var targets: [TapTarget] = []
    @State private var timeRemaining: Int = 7
    @State private var tapsCount: Int = 0
    @State private var gameTimer: Timer?
    @State private var spawnTimer: Timer?
    
    let containerWidth: CGFloat
    let containerHeight: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(targets) { target in
                TapTargetView(
                    target: target,
                    containerWidth: containerWidth,
                    containerHeight: containerHeight
                ) {
                    handleTap(target)
                }
            }
            
            VStack {
                HStack(spacing: 20) {
                    HStack(spacing: 8) {
                        Image(systemName: "timer")
                            .font(.system(size: 16, weight: .semibold))
                        Text("\(timeRemaining)s")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(timeRemaining <= 3 ? .red : .primary)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 16, weight: .semibold))
                        Text("\(tapsCount)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )
                
                Spacer()
            }
            .padding(.top, 10)
            
            if timeRemaining == 0 {
                VStack(spacing: 15) {
                    Image(systemName: "flag.checkered")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    
                    Text("Time's up!")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    Text("\(tapsCount) taps")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            setupGame()
        }
        .onDisappear {
            cleanup()
        }
    }
    
    func setupGame() {
        startGameTimer()
        startSpawning()
    }
    
    func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                endGame()
            }
        }
    }
    
    func startSpawning() {
        spawnTarget()
        
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            if timeRemaining > 0 {
                spawnTarget()
            }
        }
    }
    
    func spawnTarget() {
        let colors: [Color] = [.blue, .cyan, .purple, .pink, .green, .orange, .red, .yellow]
        let size: CGFloat = CGFloat.random(in: 50...70)
        
        let target = TapTarget(
            position: CGPoint(
                x: CGFloat.random(in: 0.15...0.85),
                y: CGFloat.random(in: 0.15...0.85)
            ),
            size: size,
            color: colors.randomElement() ?? .blue,
            createdAt: Date()
        )
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            targets.append(target)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                targets.removeAll { $0.id == target.id }
            }
        }
    }
    
    func handleTap(_ target: TapTarget) {
        if UserDefaults.standard.bool(forKey: "soundEnabled") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        
        withAnimation(.easeOut(duration: 0.2)) {
            targets.removeAll { $0.id == target.id }
        }
        
        tapsCount += 1
        score += 1
    }
    
    func endGame() {
        cleanup()
        
        if UserDefaults.standard.bool(forKey: "soundEnabled") {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            onComplete()
        }
    }
    
    func cleanup() {
        gameTimer?.invalidate()
        spawnTimer?.invalidate()
        gameTimer = nil
        spawnTimer = nil
    }
}

struct TapTargetView: View {
    let target: TapTarget
    let containerWidth: CGFloat
    let containerHeight: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                target.color.opacity(0.8),
                                target.color
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: target.size
                        )
                    )
                    .frame(width: target.size, height: target.size)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                .white.opacity(0.5),
                                .clear
                            ],
                            center: UnitPoint(x: 0.3, y: 0.3),
                            startRadius: 0,
                            endRadius: target.size * 0.3
                        )
                    )
                    .frame(width: target.size, height: target.size)
                
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: target.size * 0.4, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            .shadow(color: target.color.opacity(0.5), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(BubbleButtonStyle())
        .position(
            x: target.position.x * containerWidth,
            y: target.position.y * containerHeight
        )
        .transition(.scale.combined(with: .opacity))
    }
}
