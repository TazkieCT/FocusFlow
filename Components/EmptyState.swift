//
//  EmptyState.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI

struct EmptyState: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 16))
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(16)
    }
}
