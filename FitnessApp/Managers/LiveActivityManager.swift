import Foundation
import ActivityKit

@MainActor
class LiveActivityManager: ObservableObject {
    static let shared = LiveActivityManager()
    
    private var liveActivity: Activity<WorkoutAttributes>?
    
    private init() {}
    
    func startLiveActivity(with data: [String: Any]) {
        print("🟢 Starting Live Activity with data: \(data)")
        
        Task {
            do {
                let authorizationInfo = ActivityAuthorizationInfo()
                guard authorizationInfo.areActivitiesEnabled else {
                    print("🔴 Live Activities are not enabled on device")
                    return
                }
                
                let attributes = WorkoutAttributes(
                    workoutType: data["workoutType"] as? String ?? "Unknown",
                    workoutImageName: data["workoutImageName"] as? String ?? "",
                    startTime: data["startTime"] as? Date ?? Date()
                )
                
                let contentState = WorkoutAttributes.ContentState(
                    heartRate: data["heartRate"] as? Double ?? 0,
                    calories: data["calories"] as? Double ?? 0,
                    distance: data["distance"] as? Double ?? 0,
                    duration: data["duration"] as? TimeInterval ?? 0
                )
                
                let activityContent = ActivityContent(
                    state: contentState,
                    staleDate: Date(timeIntervalSinceNow: 60)
                )
                
                let activity = try await Activity<WorkoutAttributes>.request(
                    attributes: attributes,
                    content: activityContent
                )
                
                print("🟢 Live Activity started with ID: \(activity.id)")
                liveActivity = activity
            } catch {
                print("🔴 Error starting Live Activity: \(error.localizedDescription)")
            }
        }
    }
    
    func updateLiveActivity(with data: [String: Any]) {
        print("🟢 Updating Live Activity with data: \(data)")
        
        guard let liveActivity = liveActivity else {
            print("🔴 No active Live Activity to update")
            return
        }
        
        let contentState = WorkoutAttributes.ContentState(
            heartRate: data["heartRate"] as? Double ?? 0,
            calories: data["calories"] as? Double ?? 0,
            distance: data["distance"] as? Double ?? 0,
            duration: data["duration"] as? TimeInterval ?? 0
        )
        
        let activityContent = ActivityContent(
            state: contentState,
            staleDate: Date(timeIntervalSinceNow: 60)
        )
        
        Task {
            do {
                try await liveActivity.update(activityContent)
                print("🟢 Live Activity updated successfully")
            } catch {
                print("🔴 Error updating Live Activity: \(error.localizedDescription)")
            }
        }
    }
    
    func endLiveActivity() {
        print("🟢 Ending Live Activity")
        
        guard let liveActivity = liveActivity else {
            print("🔴 No active Live Activity to end")
            return
        }
        
        Task {
            do {
                try await liveActivity.end(dismissalPolicy: ActivityUIDismissalPolicy.immediate)
                print("🟢 Live Activity ended successfully")
            } catch {
                print("🔴 Error ending Live Activity: \(error.localizedDescription)")
            }
        }
    }
} 
