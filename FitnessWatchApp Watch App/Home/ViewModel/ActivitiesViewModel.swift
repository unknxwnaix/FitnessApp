//
//  WeeklyActivities.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/22/25.
//

import SwiftUI

class ActivitiesViewModel: ObservableObject {
    @Published var activities = [Activity]()
    
    let healthManager = HealthManager.shared
    
    init() {
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                fetchTodaySteps()
                fetchCurrentWeekActivities()
                fetchLatestHeartRate()
                fetchLatestSleepDuration()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Fitness Activity
    func fetchTodaySteps() {
        healthManager.fetchTodaySteps { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let activity):
                DispatchQueue.main.async {
                    self.activities.append(activity)
                }
            }
        }
    }
    
    func fetchCurrentWeekActivities() {
        healthManager.fetchCurrentWeekWorkoutStats { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let activities):
                DispatchQueue.main.async {
                    self.activities.append(contentsOf: activities)
                }
            }
        }
    }
    
    func fetchLatestHeartRate() {
        healthManager.fetchLatestHeartRate() { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let activity):
                DispatchQueue.main.async {
                    self.activities.append(activity)
                }
            }
        }
    }
    
    func fetchLatestSleepDuration() {
        healthManager.getLastSleepAnalysis { sleep in
            if let sleep = sleep {
                print("Последний сохранённый сон: \(sleep) кг")
            }
        }
    }
}
