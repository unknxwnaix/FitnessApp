//
//  HealthManager.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import Foundation
import HealthKit

class HealthManager {
    
    static let shared = HealthManager()
    
    let store = HKHealthStore()
    
    private init() {
        Task {
            do {
                try await reguestHealthKitAccess()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func reguestHealthKitAccess() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        let workout = HKSampleType.workoutType()
        
        let healthTypes: Set = [calories, exercise, stand, steps, workout]
        
        try await store.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    func fetchTodayCaloriesBurned(completion: @escaping (Result<Double, Error>) -> Void) {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(calorieCount))
        }
        
        store.execute(query)
    }
    
    func fetchTodayExerciseTime(completion: @escaping (Result<Double, Error>) -> Void) {
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let exetciseTime = quantity.doubleValue(for: .minute())
            completion(.success(exetciseTime))
        }
        
        store.execute(query)
    }
    
    func fetchTodayStandHours(completion: @escaping (Result<Int, Error>) -> Void) {
        let stand = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let samples = results as? [HKCategorySample], error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let standCount = samples.filter({ $0.value == 0 }).count
            completion(.success(standCount))
        }
        
        store.execute(query)
    }
    
    // MARK: Fitness Activity
    func fetchTodaySteps(completion: @escaping (Result<FitnessActivity, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            let activity = FitnessActivity(title: "Today Steps", subtitle: "Goal: 10000", image: "figure.walk", tintColor: .green, amount: steps.formattedNumberString())
            completion(.success(activity))
        }
        
        store.execute(query)
    }
    
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[FitnessActivity], Error>) -> Void) {
        let workout = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil, let self = self else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            var runningCount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            var walkingCount: Int = 0
            
            for workout in workouts {
                
                let duration = Int(workout.duration) / 60
                
                if workout.workoutActivityType == .running {
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    strengthCount += duration
                } else if workout.workoutActivityType == .soccer {
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    basketballCount += duration
                } else if workout.workoutActivityType == .stairs {
                    stairsCount += duration
                } else if workout.workoutActivityType == .walking {
                    walkingCount += duration
                }
            }
            
            let activities = generateActivitiesFromDurations(running: runningCount, strenth: strengthCount, soccer: soccerCount, basketball: basketballCount, stairs: stairsCount, walking: walkingCount)
            completion(.success(activities))
        }
        
        store.execute(query)
    }
    
    func generateActivitiesFromDurations(running: Int, strenth: Int, soccer: Int, basketball: Int, stairs: Int, walking: Int) -> [FitnessActivity] {
        return [
            FitnessActivity(title: "Ходьба", subtitle: "На этой неделе", image: "figure.walk", tintColor: .green, amount: "\(walking) мин"),
            FitnessActivity(title: "Бег", subtitle: "На этой неделе", image: "figure.run", tintColor: .teal, amount: "\(running) мин"),
            FitnessActivity(title: "Силовые", subtitle: "На этой неделе", image: "dumbbell", tintColor: .blue, amount: "\(strenth) мин"),
            FitnessActivity(title: "Футбол", subtitle: "На этой неделе", image: "figure.soccer", tintColor: .indigo, amount: "\(soccer) мин"),
            FitnessActivity(title: "Баскетбол", subtitle: "На этой неделе", image: "figure.basketball", tintColor: .purple, amount: "\(basketball) мин"),
            FitnessActivity(title: "Лестница", subtitle: "На этой неделе", image: "figure.stairs", tintColor: .yellow, amount: "\(stairs) мин"),
        ]
    }
    
    //MARK: Recent Workouts
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void) {
        let workout = HKSampleType.workoutType()
        let (startDate, endDate) = month.fetchMonthStartAndEndDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let sortDiscriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDiscriptor]) { _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let workoutsArray = workouts.map({ Workout(title: $0.workoutActivityType.name, image: $0.workoutActivityType.image, tintColor: $0.workoutActivityType.color, duration: "\(Int($0.duration)/60) mins", date: $0.startDate.formatWorkoutDate(), calories: $0.totalEnergyBurned?.doubleValue(for: .kilocalorie()).formattedNumberString() ?? "-") })
            
            completion(.success(workoutsArray))
        }
        
        store.execute(query)
    }
}

//MARK: ChartsView Data
extension HealthManager {
    struct YearChartDataResult {
        let ytd: [MonthlyStepModel]
        let oneYear: [MonthlyStepModel]
    }
    
    struct ThreeMonthChartDataResult {
        let oneWeek: [DailyStepModel]
        let oneMonth: [DailyStepModel]
        let threeMonths: [DailyStepModel]
    }
    
    func fetchYTDAndOneYearData(completion: @escaping (Result<YearChartDataResult, Error>) -> Void ) {
        let steps = HKQuantityType(.stepCount)
        let calendar = Calendar.current
        
        var oneYearMonth = [MonthlyStepModel]()
        var ytdMonth = [MonthlyStepModel]()
        
        for i in 0...11 {
            let month = calendar.date(byAdding: .month, value: -i, to: Date()) ?? Date()
            
            let (startOfMonth, endOfMonth) = month.fetchMonthStartAndEndDate()
            let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: endOfMonth)
            
            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
                guard let count = results?.sumQuantity()?.doubleValue(for: .count() ), error == nil else {
                    completion(.failure(URLError(.badURL)))
                    return
                }
                
                if i == 0 {
                    oneYearMonth.append(MonthlyStepModel(date: month, count: Int(count)))
                    ytdMonth.append(MonthlyStepModel(date: month, count: Int(count)))
                } else {
                    oneYearMonth.append(MonthlyStepModel(date: month, count: Int(count)))
                    
                    if calendar.component(.year, from: Date()) == calendar.component(.year, from: month) {
                        ytdMonth.append(MonthlyStepModel(date: month, count: Int(count)))
                    }
                }
                
                if i == 11 {
                    completion(.success(YearChartDataResult(ytd: ytdMonth, oneYear: oneYearMonth)) )
                }
            }
            
            store.execute(query)
        }
    }

    func fetchThreeMonthStepData(completion: @escaping (Result<ThreeMonthChartDataResult, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let calendar = Calendar.current

        var weekSteps = [DailyStepModel]()
        var monthSteps = [DailyStepModel]()
        var threeMonthSteps = [DailyStepModel]()

        let now = Date()
        
        for i in 0..<90 {
            guard let day = calendar.date(byAdding: .day, value: -i, to: now) else { continue }
            let startOfDay = calendar.startOfDay(for: day)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay

            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay)
            
            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
                guard let count = results?.sumQuantity()?.doubleValue(for: .count()), error == nil else {
                    completion(.failure(URLError(.badURL)))
                    return
                }

                let stepModel = DailyStepModel(date: startOfDay, count: Int(count))
                
                if i < 7 {
                    weekSteps.append(stepModel)
                }
                if i < 30 {
                    monthSteps.append(stepModel)
                }
                threeMonthSteps.append(stepModel)

                if i == 89 {
                    completion(.success(ThreeMonthChartDataResult(oneWeek: weekSteps, oneMonth: monthSteps, threeMonths: threeMonthSteps)))
                }
            }
            
            store.execute(query)
        }
    }
}

//MARK: Leaderboard View
extension HealthManager {
    func fetchCurrentWeekStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
             
            completion(.success(steps))
        }
        
        store.execute(query)
    }
}
