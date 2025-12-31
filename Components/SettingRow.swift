//
//  SettingRow.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//
import SwiftUI

struct SettingRow: View {
    let icon: String
    let title: String
    let tint: Color
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(tint)
                .frame(width: 32)

            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .frame(height: 52)
    }
}
