//
//  WorkoutDetailRow.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/22/25.
//

import SwiftUI

struct WorkoutDetailRow: View {
    let iconName: String
    let iconColor: Color
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundStyle(iconColor)
                .frame(width: 24, height: 24)
            
            Text(text)
        }
    }
}


#Preview {
    WorkoutDetailRow(iconName: "figure.walking", iconColor: .red, text: "Привет")
}
