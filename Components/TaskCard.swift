//
//  TaskCard.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI

struct TaskCard: View {
    let image: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 14) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)

            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)

            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(width: 260, height: 280)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.95))
        )
        .shadow(
            color: Color.black.opacity(0.15),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}
