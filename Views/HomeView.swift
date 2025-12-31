//
//  HomeView.swift
//  Focus Flow
//
//  Created by Hush on 24/10/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    Text("FocusFlow")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Spacer()

                    VStack(spacing: 24) {
                        NavigationLink(destination: TaskSelectionView()) {
                            PrimaryButton(title: "Start a new task!")
                        }

                        NavigationLink(destination: SettingsView()) {
                            PrimaryButton(title: "Settings")
                        }
                    }

                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    HomeView()
        .previewInterfaceOrientation(.landscapeLeft)
}
