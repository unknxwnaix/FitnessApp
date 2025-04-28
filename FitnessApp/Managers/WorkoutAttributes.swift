import Foundation
import ActivityKit

struct WorkoutAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var heartRate: Double
        var calories: Double
        var distance: Double
        var duration: TimeInterval
    }
    
    var workoutType: String
    var startTime: Date
}