//
//  PINInputView.swift
//  Focus Flow
//
//  Created by Hush on 10/12/25.
//

import SwiftUI

struct PINInputView: View {
    @State private var pin: String = ""
    @State private var showError = false
    @State private var navigateToParental = false
    
    private let correctPIN = "1234"
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            HStack(spacing: 60) {
                VStack(spacing: 20) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("Parental Mode")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Enter PIN")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    HStack(spacing: 15) {
                        ForEach(0..<4) { index in
                            Circle()
                                .fill(index < pin.count ? Color.blue : Color.gray.opacity(0.3))
                                .frame(width: 18, height: 18)
                        }
                    }
                    .padding(.top, 10)
                    
                    if showError {
                        Text("Wrong PIN")
                            .foregroundColor(.red)
                            .font(.system(size: 12))
                    }
                }
                .frame(width: 250)
                
                VStack(spacing: 12) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 15) {
                            ForEach(1...3, id: \.self) { col in
                                let number = row * 3 + col
                                NumberButton(number: "\(number)") {
                                    addDigit("\(number)")
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 15) {
                        Color.clear.frame(width: 70, height: 70)
                        NumberButton(number: "0") { addDigit("0") }
                        Button(action: deleteDigit) {
                            Image(systemName: "delete.left.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                                .frame(width: 70, height: 70)
                                .background(Color(white: 0.95))
                                .cornerRadius(35)
                        }
                    }
                }
            }
            
            NavigationLink(destination: ParentalDashboardView(), isActive: $navigateToParental) {
                EmptyView()
            }
        }
        .navigationTitle("PIN")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            pin = ""
            showError = false
        }
    }
    
    func addDigit(_ digit: String) {
        guard pin.count < 4 else { return }

        if UserDefaults.standard.bool(forKey: "soundEnabled") {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

        pin += digit
        showError = false
        
        if pin.count == 4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if pin == correctPIN {
                    if UserDefaults.standard.bool(forKey: "soundEnabled") {
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                    navigateToParental = true
                } else {
                    showError = true
                    if UserDefaults.standard.bool(forKey: "soundEnabled") {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        pin = ""
                        showError = false
                    }
                }
            }
        }
    }
    
    func deleteDigit() {
        if !pin.isEmpty {
            pin.removeLast()
            showError = false
        }
    }
}

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

#Preview {
    NavigationStack {
        PINInputView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
