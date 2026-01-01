//
//  GameModel.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 01/01/26.
//

import SwiftUI

struct Bubble: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGFloat
    let color: Color
}

struct ColorMatchItem: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGFloat
    let color: Color
    let shape: ColorMatchShape
}

enum ColorMatchShape {
    case circle
    case square
    case triangle
    case diamond
    case star
    
    static func random() -> ColorMatchShape {
        [.circle, .square, .triangle, .diamond, .star].randomElement() ?? .circle
    }
}

struct TapTarget: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGFloat
    let color: Color
    let createdAt: Date
}
