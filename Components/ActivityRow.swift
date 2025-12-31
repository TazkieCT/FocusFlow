//
//  ActivityRow.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI

struct ActivityRow: View {
    let taskName: String
    let date: String
    let completed: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(taskName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                Text(date)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                .foregroundColor(completed ? .green : .gray)
                .font(.title2)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}
