//
//  HomeViewModel.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var calories: Int = 0
    @Published var exercise: Int = 0
    @Published var stand: Int = 0
    
    let healthManager = HealthManager.shared
    
    
    init() {
        Task {
            do {
                try await healthManager.reguestHealthKitAccess()
                
                fetchTodayCalories()
                fetchTodayExerciseTime()
                fetchTodayStandHours()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTodayCalories() {
        healthManager.fetchTodayCaloriesBurned { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let calories):
                DispatchQueue.main.async {
                    self.calories = Int(calories)
                }
            }
        }
    }
    
    func fetchTodayExerciseTime() {
        healthManager.fetchTodayExerciseTime { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let exercise):
                DispatchQueue.main.async {
                    self.exercise = Int(exercise)
                }
            }
        }
    }
    
    func fetchTodayStandHours() {
        healthManager.fetchTodayStandHours { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let hours):
                DispatchQueue.main.async {
                    self.stand = hours
                }
            }
        }
    }
}
