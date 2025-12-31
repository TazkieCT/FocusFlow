//
//  StoryIntroView.swift
//  Focus Flow
//
//  Created by Hush on 13/11/25.
//

import SwiftUI

struct StoryIntroView: View {
    let taskTitle: String
    let storyPreview: String
    let characterImage: String
    let videoFileName: String

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 30) {
                Image(characterImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 10)

                Text(storyPreview)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 80)

                NavigationLink(destination: VideoGameplayView(
                    taskTitle: taskTitle,
                    videoFileName: videoFileName
                )) {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                            .font(.title3)
                        Text("Start the Story")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(width: 280, height: 60)
                    .background(Color.black)
                    .cornerRadius(12)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(taskTitle)
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
