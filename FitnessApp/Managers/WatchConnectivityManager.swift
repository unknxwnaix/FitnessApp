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
            print("🟢 Watch: WCSession is supported and activated")
            print("🟢 Watch: Session is reachable: \(WCSession.default.isReachable)")
        } else {
            print("🔴 Watch: WCSession is not supported")
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
                LiveActivityManager.shared.endLiveActivity()
                return
            }
            
            print("🟢 New workout data received")
            self.isWorkoutActive = true
            
            let wasEmpty = self.workoutData.isEmpty
            self.workoutData = applicationContext
            
            if wasEmpty {
                print("🟢 Starting new Live Activity")
                LiveActivityManager.shared.startLiveActivity(with: applicationContext)
            } else {
                print("🟢 Updating existing Live Activity")
                LiveActivityManager.shared.updateLiveActivity(with: applicationContext)
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
