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
            Image("background_plain2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            HStack(spacing: 60) {
                VStack(spacing: 20) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 72))
                        .foregroundColor(.yellow)

                    Text(isTaskComplete ? "Great Job!" : "Well Done!")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.black)

                    Text(taskTitle)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                }

                VStack(spacing: 28) {
                    VStack(spacing: 8) {
                        Text("Score")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)

                        Text("\(score)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.black)
                    }

                    HStack(spacing: 40) {
                        VStack(spacing: 8) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.green)

                            Text("+\(coinsEarned)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.green)
                        }

                        VStack(spacing: 8) {
                            Image(systemName: "star.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.orange)

                            Text("New Points")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 32)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    Button {
                        if isTaskComplete {
                            dismiss()
                        } else {
                            navigateToTaskSelection = true
                        }
                    } label: {
                        PrimaryButton(
                            title: isTaskComplete ? "Done" : "Continue"
                        )
                    }
                }
            }
            .padding(.horizontal, 60)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToTaskSelection) {
            TaskSelectionView()
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
