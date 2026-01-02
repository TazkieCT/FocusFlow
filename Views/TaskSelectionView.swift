//
//  TaskSelectionView.swift
//  Focus Flow
//
//  Created by Hush on 12/11/25.
//

import SwiftUI

struct TaskSelectionView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Image("background_task")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Text("Choose Today’s Mission")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                    .padding(.top, 40)

                HStack(spacing: 48) {
                    NavigationLink(destination: StoryIntroView(
                        taskTitle: "Tooth Brushing",
                        storyPreview: "Belajar cara menyikat gigi yang baik! Petualangan memahami mulut kita.",
                        characterImage: "IntroStory",
                        videoFileName: "brush_teeth"
                    )) {
                        TaskCard(
                            image: "CardBrushTeeth",
                            title: "Tooth Brushing",
                            subtitle: "Ayo pahami gigi kita!"
                        )
                    }

                    NavigationLink(destination: StoryIntroView(
                        taskTitle: "Making the Bed",
                        storyPreview: "Bangun pagi gosok gigi, eits jangan lupa merapikan kasurmu!",
                        characterImage: "IntroStory2",
                        videoFileName: "make_a_bed"
                    )) {
                        TaskCard(
                            image: "CardMakeBed",
                            title: "Making the Bed",
                            subtitle: "Merapikan kasur bersama Mr.Pigeon!"
                        )
                    }
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.horizontal, 40)

            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            BackButton(title: "Back") {
                                dismiss()
                            }

                            Spacer()
                        }
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
        TaskSelectionView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
