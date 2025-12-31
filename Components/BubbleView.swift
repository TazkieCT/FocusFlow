//
//  BubbleView.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI

struct BubbleView: View {
    let bubble: Bubble
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
                                bubble.color.opacity(0.8),
                                bubble.color
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: bubble.size
                        )
                    )
                    .frame(width: bubble.size, height: bubble.size)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                .white.opacity(0.4),
                                .clear
                            ],
                            center: UnitPoint(x: 0.3, y: 0.3),
                            startRadius: 0,
                            endRadius: bubble.size * 0.4
                        )
                    )
                    .frame(width: bubble.size, height: bubble.size)
                
                Image(systemName: "sparkles")
                    .font(.system(size: bubble.size * 0.35, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            .shadow(color: bubble.color.opacity(0.5), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(BubbleButtonStyle())
        .position(
            x: bubble.position.x * containerWidth,
            y: bubble.position.y * containerHeight
        )
        .transition(.scale.combined(with: .opacity))
    }
}
