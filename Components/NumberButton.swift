//
//  NumberButton.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI

struct NumberButton: View {
    let number: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(number)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 70, height: 70)
                .background(Color(white: 0.95))
                .cornerRadius(35)
        }
    }
}
