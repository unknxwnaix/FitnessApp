import Foundation
import HealthKit

@Observable
class WorkoutMetrics {
    var heartRate: Double = 0
    var averageHeartRate: Double = 0
    var energyBurned: Double = 0
    var distance: Double = 0
    var speed: Double = 0
    var averageSpeed: Double = 0
    var stepStrokeCount: Double = 0
    
    var workoutConfiguration: HKWorkoutConfiguration
    var subActivityConfiguration: HKWorkoutConfiguration?
    
    init(workoutConfiguration: HKWorkoutConfiguration) {
        self.workoutConfiguration = workoutConfiguration
    }
    
    func updateMetrics(for type: HKQuantityType, with statistics: HKStatistics?) {
        switch type {
        case HKQuantityType(.heartRate):
            heartRate = heartRate(from: statistics)
            averageHeartRate = averageHeartRate(from: statistics)
            
        case HKQuantityType(.activeEnergyBurned):
            energyBurned = energyBurned(from: statistics)
            
        case HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.distanceCycling),
            HKQuantityType(.distanceSwimming):
            distance = distance(from: statistics)
            
        case HKQuantityType(.walkingSpeed),
            HKQuantityType(.cyclingSpeed),
            HKQuantityType(.runningSpeed):
            speed = speed(from: statistics)
            averageSpeed = averageSpeed(from: statistics)
            
        case HKQuantityType(.swimmingStrokeCount):
            stepStrokeCount = strokeCount(from: statistics)
            
        case HKQuantityType(.stepCount):
            stepStrokeCount = stepCount(from: statistics)
            
        default:
            break
        }
    }
    
    private func heartRate(from statistics: HKStatistics?) -> Double {
        guard let statistics = statistics,
              let quantity = statistics.mostRecentQuantity() else {
            return 0
        }
        return quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
    }
    
    private func averageHeartRate(from statistics: HKStatistics?) -> Double {
        guard let statistics = statistics,
              let quantity = statistics.averageQuantity() else {
            return 0
        }
        return quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
    }
    
    private func energyBurned(from statistics: HKStatistics?) -> Double {
        guard let statistics = statistics,
              let quantity = statistics.sumQuantity() else {
            return 0
        }
        return quantity.doubleValue(for: HKUnit.kilocalorie())
    }
    
    private func distance(from statistics: HKStatistics?) -> Double {
        guard let statistics = statistics,
              let quantity = statistics.sumQuantity() else {
            return 0
        }
        return quantity.doubleValue(for: HKUnit.meter())
    }
    
    private func speed(from statistics: HKStatistics?) -> Double {
        guard let statistics = statistics,
              let quantity = statistics.mostRecentQuantity() else {
            return 0
        }
        return quantity.doubleValue(for: HKUnit.meter().unitDivided(by: .second()))
    }
    
    private func averageSpeed(from statistics: HKStatistics?) -> Double {
        guard let statistics = statistics,
              let quantity = statistics.averageQuantity() else {
            return 0
        }
        return quantity.doubleValue(for: HKUnit.meter().unitDivided(by: .second()))
    }
    
    private func strokeCount(from statistics: HKStatistics?) -> Double {
        guard let statistics = statistics,
              let quantity = statistics.sumQuantity() else {
            return 0
        }
        return quantity.doubleValue(for: HKUnit.count())
    }
    
    private func stepCount(from statistics: HKStatistics?) -> Double {
        guard let statistics = statistics,
              let quantity = statistics.sumQuantity() else {
            return 0
        }
        return quantity.doubleValue(for: HKUnit.count())
    }
} 