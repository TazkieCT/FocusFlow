//
//  PINInputView.swift
//  Focus Flow
//
//  Created by Hush on 10/12/25.
//

import SwiftUI

struct PINInputView: View {
    @AppStorage("parentPIN") private var storedPIN: String = ""

    @State private var pin: String = ""
    @State private var confirmPIN: String = ""
    @State private var showError = false
    @State private var navigateToParental = false
    @State private var isSetupMode = false

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

                    Text(subtitleText)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    HStack(spacing: 15) {
                        ForEach(0..<4, id: \.self) { index in
                            Circle()
                                .fill(index < pin.count ? Color.blue : Color.gray.opacity(0.3))
                                .frame(width: 18, height: 18)
                        }
                    }
                    .padding(.top, 10)

                    if showError {
                        Text(errorText)
                            .foregroundColor(.red)
                            .font(.system(size: 12))
                    }
                }
                .frame(width: 260)

                VStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { row in
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

                        NumberButton(number: "0") {
                            addDigit("0")
                        }

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

            NavigationLink(
                destination: ParentalDashboardView(),
                isActive: $navigateToParental
            ) {
                EmptyView()
            }
        }
        .navigationTitle("PIN")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isSetupMode = storedPIN.isEmpty
            pin = ""
            confirmPIN = ""
            showError = false
        }
    }

    private var subtitleText: String {
        if isSetupMode {
            return confirmPIN.isEmpty ? "Create PIN" : "Confirm PIN"
        } else {
            return "Enter PIN"
        }
    }

    private var errorText: String {
        isSetupMode ? "PINs do not match" : "Wrong PIN"
    }

    private func addDigit(_ digit: String) {
        guard pin.count < 4 else { return }

        if UserDefaults.standard.bool(forKey: "soundEnabled") {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

        pin += digit
        showError = false

        if pin.count == 4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                isSetupMode ? handleSetupFlow() : handleVerifyFlow()
            }
        }
    }

    private func handleSetupFlow() {
        if confirmPIN.isEmpty {
            confirmPIN = pin
            pin = ""
        } else {
            if pin == confirmPIN {
                storedPIN = pin
                navigateToParental = true
            } else {
                showError = true
                pin = ""
                confirmPIN = ""

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showError = false
                }
            }
        }
    }

    private func handleVerifyFlow() {
        if pin == storedPIN {
            navigateToParental = true
        } else {
            showError = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                pin = ""
                showError = false
            }
        }
    }

    private func deleteDigit() {
        if !pin.isEmpty {
            pin.removeLast()
            showError = false
        }
    }
}

#Preview {
    NavigationStack {
        PINInputView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
