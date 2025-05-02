//
//  WorkoutDetailMainView.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/21/25.
//

import SwiftUI

struct WorkoutDetailView: View {
    public let workout: WorkoutDetail
    private var gradient: LinearGradient {
        return LinearGradient(colors: [workout.tintColor.opacity(0.4), .black], startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                gradient
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Image(systemName: workout.image)
                                .font(.system(size: 25))
                                .foregroundStyle(workout.tintColor)
                                .frame(width: 50, height: 50)
                                .background {
                                    Circle()
                                        .foregroundStyle(workout.tintColor.opacity(0.4))
                                }
                            
                            Text(workout.title)
                                .font(.system(size: 25))
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    
                    HStack {
                        Label(workout.date, systemImage: "calendar")
                        
                        Spacer()
                        
                        Label(workout.duration, systemImage: "clock")
                    }
                    .font(.caption)
                    
                    Divider()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 5) {
                            if !workout.averageHeartRate.contains("-") {
                                WorkoutDetailRow(iconName: "heart", iconColor: Color.fitnessGreenMain, text: workout.averageHeartRate)
                            }
                            if !workout.pace.contains("-") {
                                WorkoutDetailRow(iconName: "speedometer", iconColor: .orange, text: workout.pace)
                            }
                            if !workout.calories.contains("-") {
                                WorkoutDetailRow(iconName: "flame.fill", iconColor: .red, text: workout.calories)
                            }
                            if !workout.distance.contains("-") {
                                WorkoutDetailRow(iconName: "arrow.left.and.right", iconColor: .blue, text: workout.distance)
                            }
                            if !workout.steps.contains("-") {
                                WorkoutDetailRow(iconName: "figure.walk", iconColor: .purple, text: workout.steps)
                            }
                        }
                        .font(.title3.bold())
                        .fontDesign(.monospaced)
                    }
                    
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    WorkoutDetailView(workout: WorkoutDetail.mock)
}
