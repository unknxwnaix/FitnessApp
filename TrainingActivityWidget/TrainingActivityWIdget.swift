//
//  TrainingActivityWIdget.swift
//  TrainingActivityWIdget
//
//  Created by Maxim Dmitrochenko on 4/27/25.
//

import WidgetKit
import SwiftUI

struct TrainingActivityWIdget: Widget {
    let kind: String = "TrainingActivityWIdget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WorkoutAttributes.self) { context in
            ZStack {
                Color.fitnessGreenMain.opacity(0.4)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("\(context.attributes.workoutType)", systemImage: context.attributes.workoutImageName)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(formatDuration(context.state.duration))
                            .font(.headline)
                            .contentTransition(.numericText())
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .background(Color.fitnessGreenMain)
                    
                    HStack(spacing: 30) {
                        VStack(alignment: .leading) {
                            Text("\(Int(context.state.heartRate))")
                                .font(.title2)
                                .fontDesign(.rounded)
                                .contentTransition(.numericText())
                                .bold()
                            
                            Text("УД/МИН")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(Int(context.state.calories))")
                                .font(.title2)
                                .fontDesign(.rounded)
                                .contentTransition(.numericText())
                                .bold()
                            Text("ККАЛ")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(formatDistance(context.state.distance))
                                .font(.title2)
                                .fontDesign(.rounded)
                                .contentTransition(.numericText())
                                .bold()
                            Text("KM")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.attributes.workoutType)
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(formatDuration(context.state.duration))
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(Int(context.state.heartRate))")
                                .font(.title3)
                                .bold()
                            Text("УД/МИН")
                                .font(.caption2)
                        }
                        
                        VStack {
                            Text("\(Int(context.state.calories))")
                                .font(.title3)
                                .bold()
                            Text("ККАЛ")
                                .font(.caption2)
                        }
                        
                        VStack {
                            Text(formatDistance(context.state.distance))
                                .font(.title3)
                                .bold()
                            Text("KM")
                                .font(.caption2)
                        }
                    }
                }
            } compactLeading: {
                Text(context.attributes.workoutType)
                    .font(.caption)
            } compactTrailing: {
                Text(formatDuration(context.state.duration))
                    .font(.caption)
            } minimal: {
                Text("\(Int(context.state.heartRate))")
                    .font(.caption)
            }
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func formatDistance(_ distance: Double) -> String {
        let kilometers = distance / 1000
        return String(format: "%.3f", kilometers)
    }
}
