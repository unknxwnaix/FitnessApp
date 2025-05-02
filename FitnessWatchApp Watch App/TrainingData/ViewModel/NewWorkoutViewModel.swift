//
//  NewWorkoutViewModel.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 5/1/25.
//

import Foundation
import HealthKit

class NewWorkoutViewModel: ObservableObject {
    @Published public var selectedWorkoutType: HKWorkoutActivityType? = nil
    @Published public var showConfigurationSheet: Bool = false
    
    @Published public var swimLocation: HKWorkoutSwimmingLocationType = .pool
    @Published public var lapLength: Int = 400
    
    // MARK: Location of Workout type is HKWorkoutSessionLocationType
    @Published public var activityLocation: HKWorkoutSessionLocationType = .outdoor
}
