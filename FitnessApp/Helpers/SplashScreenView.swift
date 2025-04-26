//
//  SplashScreen.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 4/19/25.
//
import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            if isActive {
                FitnessTabView() // Ваш основной экран
            } else {
                LottieView(
                    name: "SplashScreen",
                    loopMode: .playOnce,
                    animationSpeed: 1.0
                )
                .ignoresSafeArea(edges: .all)
                .scaleEffect(1.005) 
            }
        }
        .onAppear {
            // Задержка для завершения анимации (или слушайте завершение через делегат)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
