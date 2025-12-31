//
//  Focus_FlowApp.swift
//  Focus Flow
//
//  Created by Hush on 24/10/25.
//

import SwiftUI

@main
struct Focus_FlowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear {
                    AppDelegate.orientationLock = .landscape

                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
