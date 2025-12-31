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
            Color.white.ignoresSafeArea()

            VStack(spacing: 40) {
                HStack(spacing: 60) {
                    NavigationLink(destination: StoryIntroView(
                        taskTitle: "Tooth Brushing",
                        storyPreview: "Serunya Pangeran Leo melawan monster gigi sambil main bubble!",
                        characterImage: "IntroStory",
                        videoFileName: "ToothBrush"
                    )) {
                        VStack(spacing: 16) {
                            Image("CardBrushTeeth")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)

                            Text("Tooth Brushing")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)

                            Text("Lawan monster gigi!")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 240, height: 260)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    }

                    NavigationLink(destination: StoryIntroView(
                        taskTitle: "Making the Bed",
                        storyPreview: "Petualangan pahlawan merapikan kamar sambil main bubble!",
                        characterImage: "IntroStory",
                        videoFileName: "MakeBed"
                    )) {
                        VStack(spacing: 16) {
                            Image("CardMakeBed")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)

                            Text("Making the Bed")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)

                            Text("Jadi pahlawan kamar!")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 240, height: 260)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    }
                }

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Select Daily Task")
    }
}

#Preview {
    NavigationStack {
        TaskSelectionView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
