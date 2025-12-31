//
//  VideoUnavailableView.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI

struct VideoUnavailableView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.ultraThinMaterial)
            .aspectRatio(16/9, contentMode: .fit)
            .overlay(
                VStack(spacing: 20) {
                    Image(systemName: "video.slash.fill")
                        .font(.system(size: 50, weight: .regular))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white.opacity(0.8), .white.opacity(0.4)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    VStack(spacing: 8) {
                        Text("Video not available")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Continuing to completion...")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    ProgressView()
                        .scaleEffect(1.2)
                        .tint(.white)
                        .padding(.top, 5)
                }
            )
            .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
    }
}
