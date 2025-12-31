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
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                Spacer()
                Spacer()

                VStack(spacing: 25) {
                    SettingRow(
                        icon: "speaker.wave.2.fill",
                        title: "Sound Effects",
                        isOn: $soundEnabled
                    )

                    Divider()
                        .padding(.horizontal, 60)

                    NavigationLink(destination: PINInputView()) {
                        HStack {
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                                .frame(width: 40)

                            Text("Parental Mode")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(Color(white: 0.95))
                        .cornerRadius(12)
                    }

                    Divider()
                        .padding(.horizontal, 60)

                    Button(action: {
                        showResetAlert = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 24))
                                .foregroundColor(.red)
                                .frame(width: 40)

                            Text("Reset Progress")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.red)

                            Spacer()
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(Color(white: 0.95))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 40)

                Spacer()

                VStack(spacing: 8) {
                    Text("FocusFlow v1.0")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                    Text("Helping kids focus in a fun way")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 30)
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
    
    func resetProgress() {
        UserDefaults.standard.removeObject(forKey: "tasksCompleted")
        UserDefaults.standard.removeObject(forKey: "currentStreak")
        UserDefaults.standard.removeObject(forKey: "lastPlayedDate")
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.green)
                .frame(width: 40)

            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
        .background(Color(white: 0.95))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
