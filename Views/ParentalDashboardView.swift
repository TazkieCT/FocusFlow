//
//  ParentalDashboardView.swift
//  Focus Flow
//
//  Created by Hush on 10/12/25.
//

import SwiftUI

struct ParentalDashboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("tasksCompleted") private var tasksCompleted = 0
    @AppStorage("currentStreak") private var currentStreak = 0
    @AppStorage("totalPlaytime") private var totalPlaytime = 0
    @State private var showResetAlert = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        Text("View Child's Progress")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.top, 20)

                        // Stat Cards
                        HStack(spacing: 20) {
                            StatCard(icon: "checkmark.circle.fill", title: "Tasks Done", value: "\(tasksCompleted)", color: .green)
                            StatCard(icon: "flame.fill", title: "Streak", value: "\(currentStreak) days", color: .orange)
                            StatCard(icon: "clock.fill", title: "Total Play", value: "\(totalPlaytime / 60) hrs", color: .blue)
                        }
                        .padding(.horizontal, 20)

                        // Recent Progress Section
                        VStack(spacing: 15) {
                            Text("Recent Progress")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 40)

                            if tasksCompleted > 0 {
                                ActivityRow(taskName: "Tooth Brushing", date: "Today", completed: true)
                                    .padding(.horizontal, 40)
                            } else {
                                Text("No activity yet")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(.systemGray6))
                                    )
                                    .padding(.horizontal, 40)
                            }
                        }

                        // Parenting Tips Section
                        VStack(spacing: 15) {
                            Text("Parenting Tips")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 40)

                            TipCard(text: "Praise your child when they complete tasks.")
                                .padding(.horizontal, 40)
                            TipCard(text: "Supervise your child while using the app.")
                                .padding(.horizontal, 40)
                            TipCard(text: "Use the app as a learning tool.")
                                .padding(.horizontal, 40)
                        }
                        .padding(.bottom, 30)
                    }
                }

                // Bottom Buttons - Fixed at bottom
                VStack(spacing: 0) {
                    Divider()
                        .padding(.bottom, 20)

                    HStack(spacing: 20) {
                        Button(action: { showResetAlert = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.title3)
                                Text("Reset Progress")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red, lineWidth: 2)
                            )
                            .cornerRadius(12)
                        }

                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark")
                                    .font(.title3)
                                Text("Done")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.black)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
                .background(Color.white)
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
            Text("All child's progress will be reset. Are you sure?")
        }
    }

    func resetProgress() {
        tasksCompleted = 0
        currentStreak = 0
        totalPlaytime = 0
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)

            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct ActivityRow: View {
    let taskName: String
    let date: String
    let completed: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(taskName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                Text(date)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                .foregroundColor(completed ? .green : .gray)
                .font(.title2)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct TipCard: View {
    let text: String

    var body: some View {
        HStack {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.orange)
                .font(.title3)

            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

#Preview {
    ParentalDashboardView()
        .previewInterfaceOrientation(.landscapeLeft)
}
