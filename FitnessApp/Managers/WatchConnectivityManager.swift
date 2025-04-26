import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    private var session: WCSession?
    
    @Published var isReachable = false
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func sendMessage(_ message: [String: Any]) {
        guard let session = session, session.activationState == .activated else {
            print("Сессия не активирована")
            return
        }
        
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil) { error in
                print("Ошибка отправки сообщения: \(error.localizedDescription)")
            }
        } else {
            do {
                try session.updateApplicationContext(message)
            } catch {
                print("Ошибка обновления контекста: \(error.localizedDescription)")
            }
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Ошибка активации сессии: \(error.localizedDescription)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Сессия стала неактивной")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Сессия деактивирована")
        session.activate()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Обработка входящих сообщений от часов
        DispatchQueue.main.async {
            // Здесь можно обработать полученные данные
            print("Получено сообщение от часов: \(message)")
        }
    }
} 