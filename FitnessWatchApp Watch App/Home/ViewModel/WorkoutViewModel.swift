//
//  WorkoutViewModel.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/22/25.
//

import SwiftUI

class WorkoutViewModel: ObservableObject {
    
    let healthManager = HealthManager.shared
    
    var workouts = [WorkoutDetail]()
    
    @Published var workoutsDisplay = [WorkoutDetail]()
    
    init() {
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                fetchRecentWorkouts()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchRecentWorkouts() {
        healthManager.fetchWorkoutsForMonth(month: Date()) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let workouts):
                DispatchQueue.main.async {
                    self.workouts = workouts
                }
            }
        }
    }
    
    func reloadWorkouts() {
        healthManager.fetchWorkoutsForMonth(month: Date()) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let workouts):
                DispatchQueue.main.async {
                    self.workoutsDisplay = workouts
                }
            }
        }
    }
}
