//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import SwiftUI
import FirebaseCore
import WatchConnectivity

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    // Initialize and activate WatchConnectivity
    if WCSession.isSupported() {
        let session = WCSession.default
        session.delegate = WatchConnectivityManager.shared
        session.activate()
        print("🟢 iPhone: WCSession is supported and activated")
    } else {
        print("🔴 iPhone: WCSession is not supported")
    }
    
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
