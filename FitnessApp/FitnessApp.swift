//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct FitnessApp: App {
    @AppStorage("activateDarkMode") private var activateDarkMode: Bool = false
    @AppStorage("showIntro") private var showIntro: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        if UserDefaults.standard.isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "showIntro")
        }
    }

    var body: some Scene {
        WindowGroup {
            if showIntro {
                IntroView(showIntro: $showIntro)
            } else {
                SplashScreenView()
            }
        }
    }
}


extension UserDefaults {
    var isFirstLaunch: Bool {
        if self.bool(forKey: "hasLaunchedBefore") {
            return false
        } else {
            self.set(true, forKey: "hasLaunchedBefore")
            return true
        }
    }
}
