//
//  LoadingVideoView.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI

struct LoadingVideoView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.ultraThinMaterial)
            .aspectRatio(16/9, contentMode: .fit)
            .overlay(
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                    
                    Text("Loading video...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
            )
            .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
    }
}
