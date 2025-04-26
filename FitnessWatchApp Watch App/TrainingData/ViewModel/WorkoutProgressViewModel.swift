//
//  NewWorkoutViewModel.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/26/25.
//

import SwiftUI
import HealthKit

class WorkoutProgressViewModel: ObservableObject {
    private var workoutManager: WorkoutManager
    
    @Published var currentDate: Date = Date()
    public let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Published var showControl: Bool = false
    @Published var showProgressView: Bool = false
    
    @Published var selectedWorkoutType: HKWorkoutActivityType? = nil
    @Published var showNewSubActivitySheet: Bool = false
    @Published var showConfigurationSheet: Bool = false
    
    @Published var swimLocation: HKWorkoutSwimmingLocationType = .pool
    @Published var lapLength: Int = 400
    @Published var activityLocation: HKWorkoutSessionLocationType = .outdoor

    init(workoutManager: WorkoutManager) {
        self.workoutManager = workoutManager
    }
    
    @MainActor func getAllowedSubActivities() -> [HKWorkoutActivityType] {
        guard let metrics = workoutManager.workoutMetrics else {
            return []
        }
        
        if metrics.workoutConfiguration.activityType == .swimBikeRun {
            let activityTypes: [HKWorkoutActivityType] = (metrics.subActivityConfiguration == nil || metrics.subActivityConfiguration?.activityType != .transition) ? [.swimming, .cycling, .running, .transition] : [.swimming, .cycling, .running]
            return activityTypes
        }
        
        return metrics.subActivityConfiguration == nil ? [metrics.workoutConfiguration.activityType] : []
    }
}
