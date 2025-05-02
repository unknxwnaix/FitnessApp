//
//  NewWorkoutViewModel.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 5/1/25.
//

import Foundation
import HealthKit

@Observable
class NewWorkoutViewModel {
    var selectedWorkoutType: HKWorkoutActivityType? = nil
    var showConfigurationSheet: Bool = false
    
    var swimLocation: HKWorkoutSwimmingLocationType = .pool {
        didSet {
            print("Swim location changed to: \(swimLocation)")
        }
    }
    var lapLength: Int = 400 {
        didSet {
            print("Lap length changed to: \(lapLength)")
        }
    }
    
    // MARK: Location of Workout type is HKWorkoutSessionLocationType
    var activityLocation: HKWorkoutSessionLocationType = .outdoor {
        didSet {
            print("Activity location changed to: \(activityLocation)")
        }
    }
}
