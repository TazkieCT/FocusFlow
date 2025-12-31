//
//  TaskSelectionView.swift
//  Focus Flow
//
//  Created by Hush on 12/11/25.
//

import SwiftUI

struct TaskSelectionView: View {
    var body: some View {
        ZStack {
            Image("background_task")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Text("Choose Today’s Mission")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.top, 20)

                HStack(spacing: 48) {
                    NavigationLink(destination: StoryIntroView(
                        taskTitle: "Tooth Brushing",
                        storyPreview: "Serunya Pangeran Leo melawan monster gigi sambil main bubble!",
                        characterImage: "IntroStory",
                        videoFileName: "ToothBrush"
                    )) {
                        TaskCard(
                            image: "CardBrushTeeth",
                            title: "Tooth Brushing",
                            subtitle: "Lawan monster gigi!"
                        )
                    }

                    NavigationLink(destination: StoryIntroView(
                        taskTitle: "Making the Bed",
                        storyPreview: "Petualangan pahlawan merapikan kamar sambil main bubble!",
                        characterImage: "IntroStory",
                        videoFileName: "MakeBed"
                    )) {
                        TaskCard(
                            image: "CardMakeBed",
                            title: "Making the Bed",
                            subtitle: "Jadi pahlawan kamar!"
                        )
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    NavigationStack {
        TaskSelectionView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
