//
//  SettingsView.swift
//  Focus Flow
//
//  Created by Hush on 26/10/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @State private var showResetAlert = false

    var body: some View {
        ZStack {
            Image("background_plain")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            HStack {
                Spacer()

                VStack(spacing: 24) {

                    VStack(spacing: 18) {
                        SettingRow(
                            icon: "speaker.wave.2.fill",
                            title: "Sound Effects",
                            tint: .green,
                            isOn: $soundEnabled
                        )

                        Divider()

                        NavigationLink(destination: PINInputView()) {
                            SettingNavigationRow(
                                icon: "lock.shield.fill",
                                title: "Parental Mode",
                                tint: .blue
                            )
                        }

                        Divider()

                        Button {
                            showResetAlert = true
                        } label: {
                            SettingNavigationRow(
                                icon: "arrow.counterclockwise",
                                title: "Reset Progress",
                                tint: .red
                            )
                        }
                    }
                    .padding(30)
                    .background(Color.white.opacity(0.96))
                    .cornerRadius(20)
                    .frame(maxWidth: 520)

                    VStack(spacing: 6) {
                        Text("FocusFlow v1.0")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)

                        Text("Helping kids focus in a fun way")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset Progress?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                resetProgress()
            }
        } message: {
            Text("All progress and tasks will be reset. Are you sure?")
        }
    }

    private func resetProgress() {
        UserDefaults.standard.removeObject(forKey: "tasksCompleted")
        UserDefaults.standard.removeObject(forKey: "currentStreak")
        UserDefaults.standard.removeObject(forKey: "lastPlayedDate")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
