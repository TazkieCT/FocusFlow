//
//  StoryIntroView.swift
//  Focus Flow
//
//  Created by Hush on 13/11/25.
//

import SwiftUI

struct StoryIntroView: View {
    @Environment(\.dismiss) var dismiss

    let taskTitle: String
    let storyPreview: String
    let characterImage: String
    let videoFileName: String

    var body: some View {
        ZStack {
            Image("background_plain")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color.white.opacity(0.4),
                    Color.white.opacity(0.2)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Image(characterImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
                    .overlay(
                        Rectangle()
                            .stroke(Color.orange, lineWidth: 4)
                    )
                    .padding(.top, 40)

                VStack(spacing: 12) {
                    Text(taskTitle)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)

                    Text(storyPreview)
                        .font(.system(size: 18))
                        .foregroundColor(.black.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 48)

                NavigationLink {
                    VideoGameplayView(
                        taskTitle: taskTitle,
                        videoFileName: videoFileName
                    )
                } label: {
                    PrimaryButton(title: "Start the Story")
                }
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                HStack {
                    BackButton(title: "Back") {
                        dismiss()
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.leading, 24)
            .padding(.top, 34)
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    NavigationStack {
        StoryIntroView(
            taskTitle: "Tooth Brushing",
            storyPreview: "Serunya Pangeran Leo melawan monster gigi sambil main bubble!",
            characterImage: "prince_icon",
            videoFileName: "ToothBrush"
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
