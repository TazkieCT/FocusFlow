//
//  GameType.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 01/01/26.
//

import SwiftUI

enum GameType: CaseIterable {
    case bubblePop
    case colorMatch
    case tapRace
    
    var title: String {
        switch self {
        case .bubblePop:
            return "Bubble Time!"
        case .colorMatch:
            return "Color Match!"
        case .tapRace:
            return "Tap Race!"
        }
    }
    
    var instruction: String {
        switch self {
        case .bubblePop:
            return "Tap the bubbles!"
        case .colorMatch:
            return "Tap items matching the color!"
        case .tapRace:
            return "Tap as many as you can!"
        }
    }
    
    static func random() -> GameType {
        GameType.allCases.randomElement() ?? .bubblePop
    }
}
