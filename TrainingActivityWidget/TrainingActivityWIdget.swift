//
//  TrainingActivityWIdget.swift
//  TrainingActivityWIdget
//
//  Created by Maxim Dmitrochenko on 4/27/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct TrainingActivityWIdgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
    }
}

struct TrainingActivityWIdget: Widget {
    let kind: String = "TrainingActivityWIdget"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WorkoutAttributes.self) { context in
            ZStack {
                Color.fitnessGreenMain.opacity(0.4)
                
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(context.attributes.workoutType)
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
                    Text("")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("")
                    // more content
                }
            } compactLeading: {
                Text("")
            } compactTrailing: {
                Text("")
            } minimal: {
                Text("")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
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

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    TrainingActivityWIdget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
