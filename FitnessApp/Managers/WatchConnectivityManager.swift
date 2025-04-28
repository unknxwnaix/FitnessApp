import Foundation
import WatchConnectivity
import ActivityKit

@MainActor
class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    
    @Published var isWorkoutActive = false
    @Published var workoutData: [String: Any] = [:]
    private var liveActivity: Activity<WorkoutAttributes>?
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("🟢 Watch: WCSession is supported and activated")
            print("🟢 Watch: Session is reachable: \(WCSession.default.isReachable)")
        } else {
            print("🔴 Watch: WCSession is not supported")
        }
    }
    
    private func startLiveActivity(with data: [String: Any]) {
        print("🟢 Starting Live Activity with data: \(data)")
        
        let attributes = WorkoutAttributes(
            workoutType: data["workoutType"] as? String ?? "Unknown",
            startTime: data["startTime"] as? Date ?? Date()
        )
        
        let contentState = WorkoutAttributes.ContentState(
            heartRate: data["heartRate"] as? Double ?? 0,
            calories: data["calories"] as? Double ?? 0,
            distance: data["distance"] as? Double ?? 0,
            duration: data["duration"] as? TimeInterval ?? 0
        )
        
        do {
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                let activityContent = ActivityContent(
                    state: contentState,
                    staleDate: nil
                )
                
                let activity = try Activity<WorkoutAttributes>.request(
                    attributes: attributes,
                    content: activityContent
                )
                
                print("🟢 Live Activity started with ID: \(activity.id)")
                liveActivity = activity
            } else {
                print("🔴 Live Activities are not enabled")
            }
        } catch {
            print("🔴 Error starting Live Activity: \(error.localizedDescription)")
        }
    }
    
    private func updateLiveActivity(with data: [String: Any]) {
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
            staleDate: nil
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
    
    private func endLiveActivity() {
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
    
    func sendWorkoutData(_ data: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("🔴 Watch: Session is not activated")
            return
        }
        
        guard WCSession.default.isReachable else {
            print("🔴 Watch: iPhone is not reachable")
            return
        }
        
        print("🟢 Watch: Sending workout data: \(data)")
        
        workoutData = data
        isWorkoutActive = true
        
        do {
            try WCSession.default.updateApplicationContext(data)
            print("🟢 Watch: Data sent successfully")
        } catch {
            print("🔴 Watch: Error sending data: \(error.localizedDescription)")
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("🔴 Session activation failed with error: \(error.localizedDescription)")
        } else {
            print("🟢 Session activated successfully with state: \(activationState)")
        }
    }
    
    nonisolated func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("🟢 Received application context: \(applicationContext)")
        
        guard session.activationState == .activated else {
            print("🔴 Session is not activated")
            return
        }
        
        DispatchQueue.main.async {
            if applicationContext["workoutEnded"] as? Bool == true {
                print("🟢 Workout ended notification received")
                self.isWorkoutActive = false
                self.workoutData = [:]
                self.endLiveActivity()
                return
            }
            
            print("🟢 New workout data received")
            self.isWorkoutActive = true
            self.workoutData = applicationContext
            
            if self.liveActivity == nil {
                print("🟢 Starting new Live Activity")
                self.startLiveActivity(with: applicationContext)
            } else {
                print("🟢 Updating existing Live Activity")
                self.updateLiveActivity(with: applicationContext)
            }
        }
    }
    
    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {
        print("🟡 Session became inactive")
    }
    
    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        print("🟡 Session deactivated, attempting to reactivate")
        WCSession.default.activate()
    }
}
