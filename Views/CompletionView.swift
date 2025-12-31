//
//  CompletionView.swift
//  Focus Flow
//
//  Created by Hush on 24/11/25.
//

import SwiftUI

struct CompletionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var navigateToTaskSelection = false

    let taskTitle: String
    let score: Int
    let coinsEarned: Int
    let isTaskComplete: Bool

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 20)

                    Image(systemName: "trophy.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.yellow)

                    Text(isTaskComplete ? "Great Job!" : "Well Done!")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .padding(.top, 5)

                    Text("Score: \(score)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)

                    VStack(spacing: 20) {
                        Text("Rewards")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)

                        HStack(spacing: 50) {
                            VStack(spacing: 12) {
                                Image(systemName: "dollarsign.circle.fill")
                                    .font(.system(size: 35))
                                    .foregroundColor(.green)
                                Text("+\(coinsEarned)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.green)
                            }

                            VStack(spacing: 12) {
                                Image(systemName: "star.circle.fill")
                                    .font(.system(size: 35))
                                    .foregroundColor(.orange)
                                Text("New Points")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 30)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    Spacer()
                        .frame(height: 30)

                    Button(action: {
                        if isTaskComplete {
                            dismiss()
                        } else {
                            navigateToTaskSelection = true
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: isTaskComplete ? "checkmark" : "arrow.right")
                                .font(.title3)
                            Text(isTaskComplete ? "Done" : "Continue")
                                .font(.system(size: 20, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 280, height: 60)
                        .background(Color.black)
                        .cornerRadius(12)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Complete")
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $navigateToTaskSelection) {
            NavigationStack {
                TaskSelectionView()
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationStack {
        CompletionView(
            taskTitle: "Tooth Brushing",
            score: 10,
            coinsEarned: 15,
            isTaskComplete: false
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
