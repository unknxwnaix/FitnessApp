import Foundation
import WatchConnectivity

@MainActor
class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    
    @Published var isWorkoutActive = false
    @Published var workoutData: [String: Any] = [:]
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func sendWorkoutData(_ data: [String: Any]) {
        guard WCSession.default.activationState == .activated else { return }
        
        workoutData = data
        isWorkoutActive = true
        
        do {
            try WCSession.default.updateApplicationContext(data)
            print("Workout Successfully Started! Updated Data \(data)")
        } catch {
            print("Error sending workout data: \(error.localizedDescription)")
        }
    }
    
    func endWorkout() {
        guard WCSession.default.activationState == .activated else { return }
        
        isWorkoutActive = false
        workoutData = [:]
        
        do {
            try WCSession.default.updateApplicationContext(["workoutEnded": true])
            print("Successfully Ended Workout!")
        } catch {
            print("Error ending workout: \(error.localizedDescription)")
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Session activation failed with error: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            // Handle any messages from iPhone if needed
        }
    }
}
