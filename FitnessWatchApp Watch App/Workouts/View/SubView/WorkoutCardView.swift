//
//  WorkoutCardView.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/21/25.
//

import SwiftUI

struct WorkoutCardView: View {
    private let frameHeight: CGFloat = 35
    public var workout: WorkoutDetail
    
    var body: some View {
        ZStack {
            Color(.gray.opacity(0.25))
                .cornerRadius(8)
            
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(workout.tintColor.gradient.opacity(0.15))
                    
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 3))
                        .foregroundStyle(workout.tintColor)
                        .padding(1)
                    
                    Image(systemName: workout.image)
                        .foregroundStyle(workout.tintColor)
                }
                .frame(width: frameHeight, height: frameHeight)
                    
                Text(workout.title)
                    .font(.caption2)
                    .lineLimit(1)
                    .frame(maxWidth: 70, alignment: .leading)
                
                Spacer()
                
                Text(workout.date)
                    .font(.caption2)
                    .padding(.trailing, 8)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(height: frameHeight)
    }
}

#Preview {
    WorkoutCardView(workout: WorkoutDetail(
        title: "Прогулка",
        image: "figure.walk",
        tintColor: .fitnessGreenMain,
        duration: "45 мин",
        date: "20 апр",
        calories: "320 ккал",
        averageHeartRate: "105 уд/мин",
        distance: "3.2 км",
        steps: "4300 шагов", pace: "--"
    ))
}
