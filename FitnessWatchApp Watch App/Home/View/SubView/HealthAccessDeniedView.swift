//
//  HealthAccessDeniedView.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/22/25.
//

import SwiftUI

struct HealthAccessDeniedView: View {
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "heart.slash.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundStyle(.red)
            
            Text("Нет доступа к данным о здоровье")
                .font(.headline)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Откройте приложение \"Настройки\" на Apple Watch или iPhone и разрешите доступ к Здоровью для этого приложения.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    HealthAccessDeniedView()
}
