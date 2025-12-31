//
//  ParentalDashboardView.swift
//  Focus Flow
//
//  Created by Hush on 10/12/25.
//

import SwiftUI

struct ParentalDashboardView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("tasksCompleted") private var tasksCompleted = 0
    @AppStorage("currentStreak") private var currentStreak = 0
    @AppStorage("totalPlaytime") private var totalPlaytime = 0
    @State private var showResetAlert = false

    var body: some View {
        ZStack {
            Image("background_plain2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 28) {
                        Text("View Child’s Progress")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.top, 16)
                        HStack(spacing: 16) {
                            StatCard(
                                icon: "checkmark.circle.fill",
                                title: "Tasks",
                                value: "\(tasksCompleted)",
                                color: .green
                            )

                            StatCard(
                                icon: "flame.fill",
                                title: "Streak",
                                value: "\(currentStreak)d",
                                color: .orange
                            )

                            StatCard(
                                icon: "clock.fill",
                                title: "Play",
                                value: "\(totalPlaytime / 60)h",
                                color: .blue
                            )
                        }
                        .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            SectionHeader(title: "Recent Activity")

                            if tasksCompleted > 0 {
                                ActivityRow(
                                    taskName: "Tooth Brushing",
                                    date: "Today",
                                    completed: true
                                )
                            } else {
                                EmptyState(text: "No activity yet")
                            }
                        }
                        .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            SectionHeader(title: "Parenting Tips")

                            TipCard(text: "Praise your child when they complete tasks.")
                            TipCard(text: "Supervise your child while using the app.")
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                }

                VStack(spacing: 0) {
                    Divider()

                    HStack(spacing: 16) {
                        Button {
                            showResetAlert = true
                        } label: {
                            Text("Reset")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                                .cornerRadius(12)
                        }

                        Button {
                            dismiss()
                        } label: {
                            Text("Done")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(Color.black)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
                .background(Color.white.opacity(0.1))
            }
        }
        .navigationTitle("Parent Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset Progress?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                resetProgress()
            }
        } message: {
            Text("All child's progress will be reset.")
        }
    }

    private func resetProgress() {
        tasksCompleted = 0
        currentStreak = 0
        totalPlaytime = 0
    }
}

#Preview {
    ParentalDashboardView()
        .previewInterfaceOrientation(.landscapeLeft)
}
