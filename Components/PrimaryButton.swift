//
//  PrimaryButton.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 280, height: 60)
            .background(Color.black)
            .cornerRadius(12)
    }
}

#Preview {
    PrimaryButton(title: "Preview Button")
}

