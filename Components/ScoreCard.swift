//
//  ScoreCard.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI

struct ScoreCard: View {
    let score: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("\(score)")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .strokeBorder(
                            LinearGradient(
                                colors: [.white.opacity(0.3), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
    }
}
