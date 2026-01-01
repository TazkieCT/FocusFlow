//
//  ColorMatchGameView.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 01/01/26.
//

import SwiftUI

struct ColorMatchGameView: View {
    @Binding var score: Int
    @Binding var isActive: Bool
    let onComplete: () -> Void
    
    @State private var items: [ColorMatchItem] = []
    @State private var targetColor: Color = .blue
    @State private var timeRemaining: Int = 10
    @State private var correctTaps: Int = 0
    @State private var wrongTaps: Int = 0
    @State private var gameTimer: Timer?
    @State private var spawnTimer: Timer?
    @State private var showColorIndicator = true
    
    let containerWidth: CGFloat
    let containerHeight: CGFloat
    
    let availableColors: [Color] = [.blue, .cyan, .purple, .pink, .green, .orange, .red, .yellow]
    
    var body: some View {
        ZStack {
            ForEach(items) { item in
                ColorMatchItemView(
                    item: item,
                    containerWidth: containerWidth,
                    containerHeight: containerHeight
                ) {
                    handleTap(item)
                }
            }
            
            VStack {
                HStack(spacing: 20) {
                    HStack(spacing: 10) {
                        Text("Match:")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Circle()
                            .fill(targetColor)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                            )
                            .shadow(color: targetColor.opacity(0.5), radius: 8)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
                    
                    HStack(spacing: 8) {
                        Image(systemName: "timer")
                            .font(.system(size: 16, weight: .semibold))
                        Text("\(timeRemaining)s")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(timeRemaining <= 3 ? .red : .primary)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
                    
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                        Text("\(correctTaps)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.green)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
                }
                
                Spacer()
            }
            .padding(.top, 10)
            
            if timeRemaining == 0 {
                VStack(spacing: 15) {
                    Image(systemName: "paintpalette.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.purple)
                    
                    Text("Time's up!")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 5) {
                            Text("\(correctTaps)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.green)
                            Text("Correct")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 5) {
                            Text("\(wrongTaps)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.red)
                            Text("Wrong")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                )
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
        selectNewTargetColor()
        startGameTimer()
        startSpawning()
    }
    
    func selectNewTargetColor() {
        targetColor = availableColors.randomElement() ?? .blue
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showColorIndicator = true
        }
    }
    
    func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                
                if timeRemaining % 3 == 0 && timeRemaining > 0 {
                    selectNewTargetColor()
                }
            } else {
                endGame()
            }
        }
    }
    
    func startSpawning() {
        spawnItem()
        
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
            if timeRemaining > 0 {
                spawnItem()
            }
        }
    }
    
    func spawnItem() {
        let size: CGFloat = CGFloat.random(in: 50...70)
        
        let color = Bool.random() ? targetColor : availableColors.filter { $0 != targetColor }.randomElement() ?? .red
        
        let item = ColorMatchItem(
            position: CGPoint(
                x: CGFloat.random(in: 0.15...0.85),
                y: CGFloat.random(in: 0.15...0.85)
            ),
            size: size,
            color: color,
            shape: ColorMatchShape.random()
        )
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            items.append(item)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 0.3)) {
                items.removeAll { $0.id == item.id }
            }
        }
    }
    
    func handleTap(_ item: ColorMatchItem) {
        if UserDefaults.standard.bool(forKey: "soundEnabled") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        
        withAnimation(.easeOut(duration: 0.2)) {
            items.removeAll { $0.id == item.id }
        }
        
        if item.color == targetColor {
            correctTaps += 1
            score += 2
            
            if UserDefaults.standard.bool(forKey: "soundEnabled") {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        } else {
            wrongTaps += 1
            score = max(0, score - 1)
            
            if UserDefaults.standard.bool(forKey: "soundEnabled") {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }
    
    func endGame() {
        cleanup()
        
        if UserDefaults.standard.bool(forKey: "soundEnabled") {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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

struct ColorMatchItemView: View {
    let item: ColorMatchItem
    let containerWidth: CGFloat
    let containerHeight: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                shapeView
                    .fill(
                        RadialGradient(
                            colors: [
                                item.color.opacity(0.8),
                                item.color
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: item.size
                        )
                    )
                    .frame(width: item.size, height: item.size)
                
                shapeView
                    .fill(
                        RadialGradient(
                            colors: [
                                .white.opacity(0.4),
                                .clear
                            ],
                            center: UnitPoint(x: 0.3, y: 0.3),
                            startRadius: 0,
                            endRadius: item.size * 0.3
                        )
                    )
                    .frame(width: item.size, height: item.size)
            }
            .shadow(color: item.color.opacity(0.5), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(BubbleButtonStyle())
        .position(
            x: item.position.x * containerWidth,
            y: item.position.y * containerHeight
        )
        .transition(.scale.combined(with: .opacity))
    }
    
    var shapeView: AnyShape {
        switch item.shape {
        case .circle:
            AnyShape(Circle())
        case .square:
            AnyShape(Rectangle())
        case .triangle:
            AnyShape(Triangle())
        case .diamond:
            AnyShape(Diamond())
        case .star:
            AnyShape(Star())
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let numberOfPoints = 5
        
        var path = Path()
        
        for i in 0..<numberOfPoints * 2 {
            let angle = CGFloat(i) * .pi / CGFloat(numberOfPoints) - .pi / 2
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = { rect in
            shape.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}
