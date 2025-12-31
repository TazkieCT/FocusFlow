//
//  Bubble.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import SwiftUI
import AVKit
import Combine

struct Bubble: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGFloat
    let color: Color
}
