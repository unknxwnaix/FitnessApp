//
//  HealthManager.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import Foundation
import SwiftUI
import HealthKit

class HealthManager {
    
    static let shared = HealthManager()
    
    let store = HKHealthStore()
    
    let healthTypes: Set<HKObjectType> = [
        HKQuantityType(.heartRate),
        HKQuantityType(.activeEnergyBurned),
        
        HKQuantityType(.stepCount),
        HKQuantityType(.swimmingStrokeCount),
        HKQuantityType(.walkingSpeed),
        HKQuantityType(.cyclingSpeed),
        HKQuantityType(.runningSpeed),
        
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.distanceCycling),
        HKQuantityType(.distanceSwimming),
        
        HKQuantityType(.appleExerciseTime),
        HKCategoryType(.appleStandHour),
        HKSampleType.workoutType(),
        
        HKQuantityType(.appleSleepingWristTemperature),
        HKQuantityType(.heartRateVariabilitySDNN),
        HKQuantityType(.oxygenSaturation),
        HKQuantityType(.respiratoryRate),
        
        HKQuantityType(.height),
        HKQuantityType(.bodyMass),
        HKQuantityType(.bodyMassIndex),
        HKCategoryType(.sleepAnalysis),
        
        HKObjectType.activitySummaryType()
    ]
    
    private init() {
        Task {
            do {
                try await requestHealthKitAccess()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func requestHealthKitAccess() async throws {
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
    
    func getLastSleepAnalysis(completion: @escaping (TimeInterval?) -> Void) {
        print("🟢 Начало получения данных о сне из HealthKit")
        
        // 1. Проверяем доступность типа данных "анализ сна"
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            print("🔴 Ошибка: Не удалось создать тип данных для анализа сна")
            completion(nil)
            return
        }
        print("🟣 Тип данных 'анализ сна' доступен")
        
        // 2. Настраиваем сортировку (последняя запись сначала)
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: false
        )
        
        // 3. Предикат для выборки только данных за последние 7 дней
        let now = Date()
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let predicate = HKQuery.predicateForSamples(
            withStart: oneWeekAgo,
            end: now,
            options: .strictStartDate
        )
        
        // 4. Создаем запрос
        let query = HKSampleQuery(
            sampleType: sleepType,
            predicate: predicate,
            limit: 1,
            sortDescriptors: [sortDescriptor]
        ) { _, samples, error in
            
            // 5. Обрабатываем ошибку запроса
            if let error = error {
                print("🔴 Ошибка при выполнении запроса: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // 6. Проверяем наличие samples
            guard let sample = samples?.first as? HKCategorySample else {
                print("🟡 Данные о сне не найдены в HealthKit")
                completion(nil)
                return
            }
            
            // 7. Проверяем, что это именно фаза сна (а не просто "постельное время")
            guard sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue else {
                print("🟡 Найдена запись, но это не фаза сна")
                completion(nil)
                return
            }
            
            // 8. Рассчитываем длительность сна
            let duration = sample.endDate.timeIntervalSince(sample.startDate)
            let hours = duration / 3600
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            
            print("""
            🟢 Успешно получены данные:
            - Длительность сна: \(String(format: "%.1f", hours)) часов
            - Начало: \(dateFormatter.string(from: sample.startDate))
            - Конец: \(dateFormatter.string(from: sample.endDate))
            - UUID записи: \(sample.uuid)
            """)
            
            completion(duration)
        }
        
        print("🟣 Выполняем запрос к HealthKit...")
        store.execute(query)
    }
    
    // MARK: Fitness Activity
    func fetchTodaySteps(completion: @escaping (Result<Activity, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            let activity = Activity(title: "Шаги", subtitle: "Цель: 10000", image: "figure.highintensity.intervaltraining", tintColor: Color.fitnessGreenMain, amount: steps.formattedNumberString())
            completion(.success(activity))
        }
        
        store.execute(query)
    }
    
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[Activity], Error>) -> Void) {
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
    
    func generateActivitiesFromDurations(running: Int, strenth: Int, soccer: Int, basketball: Int, stairs: Int, walking: Int) -> [Activity] {
        var activities: [Activity] = []
        
        if walking > 0 {
            activities.append(Activity(title: "Ходьба", subtitle: "На этой неделе", image: "figure.walk", tintColor: Color.fitnessGreenMain, amount: "\(walking) мин"))
        }
        
        if running > 0 {
            activities.append(Activity(title: "Бег", subtitle: "На этой неделе", image: "figure.run", tintColor: .teal, amount: "\(running) мин"))
        }
        
        if strenth > 0 {
            activities.append(Activity(title: "Силовые", subtitle: "На этой неделе", image: "dumbbell", tintColor: .blue, amount: "\(strenth) мин"))
        }
        
        if soccer > 0 {
            activities.append(Activity(title: "Футбол", subtitle: "На этой неделе", image: "figure.soccer", tintColor: .indigo, amount: "\(soccer) мин"))
        }
        
        if basketball > 0 {
            activities.append(Activity(title: "Баскетбол", subtitle: "На этой неделе", image: "figure.basketball", tintColor: .purple, amount: "\(basketball) мин"))
        }
        
        if stairs > 0 {
            activities.append(Activity(title: "Лестница", subtitle: "На этой неделе", image: "figure.stairs", tintColor: .yellow, amount: "\(stairs) мин"))
        }
        
        return activities
    }

    // Получение последнего значения пульса
    func fetchLatestHeartRate(completion: @escaping (Result<Activity, Error>) -> Void) {
        let heartRateType = HKQuantityType(.heartRate)
        let predicate = HKQuery.predicateForSamples(withStart: nil, end: Date())
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]) { _, results, error in
            guard let sample = results?.first as? HKQuantitySample, error == nil else {
                completion(.failure(error ?? URLError(.badURL)))
                return
            }
            
            let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
            let activity = Activity(title: "Пульс", subtitle: "Последнее значение", image: "heart.fill", tintColor: .red, amount: "\(Int(heartRate)) уд/мин")
            completion(.success(activity))
        }
        store.execute(query)
    }
    
    // MARK: - Recent Workouts
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[WorkoutDetail], Error>) -> Void) {
        let workoutType = HKSampleType.workoutType()
        let (startDate, endDate) = month.fetchMonthStartAndEndDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] _, results, error in
            guard let self = self else { return }
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            var workoutDetails: [WorkoutDetail] = []
            let group = DispatchGroup()
            
            for workout in workouts {
                group.enter()
                
                self.fetchAverageHeartRateAndPace(for: workout) { heartRate, pace in
                    self.fetchStepCount(for: workout) { stepCount in
                        let calories = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
                        let distance = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
                        
                        let detail = WorkoutDetail(
                            title: workout.workoutActivityType.name,
                            image: workout.workoutActivityType.image,
                            tintColor: workout.workoutActivityType.color,
                            duration: "\(Int(workout.duration) / 60) мин",
                            date: workout.startDate.formatWorkoutDate(),
                            calories: calories > 0 ? calories.formattedNumberStringWithSuffix("ккал") : "--- ккал",
                            averageHeartRate: heartRate != nil ? "\(Int(heartRate!)) уд/мин" : "-- уд/мин",
                            distance: distance > 0 ? distance.formattedDistanceString() : "-,- км",
                            steps: stepCount != nil ? "\(Int(stepCount!)) шагов" : "- шагов",
                            pace: pace != nil ? pace!.formattedPaceString() : "-:-- мин/км"
                        )
                        
                        workoutDetails.append(detail)
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                //MARK: return sorted Array of Workouts
                completion(.success(workoutDetails.sorted(by: { $0.date > $1.date })))
            }
        }
        
        store.execute(query)
    }
    
    func fetchAverageHeartRateAndPace(for workout: HKWorkout, completion: @escaping (Double?, Double?) -> Void) {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let paceType = HKQuantityType.quantityType(forIdentifier: .runningSpeed)!
        
        let broaderPredicate = HKQuery.predicateForSamples(withStart: workout.startDate.addingTimeInterval(-60), end: workout.endDate.addingTimeInterval(60))
        
        let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: broaderPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, heartRateSamples, _ in
            guard let heartRateSamples = heartRateSamples as? [HKQuantitySample], !heartRateSamples.isEmpty else {
                print("Нет данных о сердечном ритме для тренировки.")
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
                return
            }
            
            let heartRates = heartRateSamples.map { $0.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) }
            let averageHeartRate = heartRates.isEmpty ? nil : heartRates.reduce(0, +) / Double(heartRates.count)
            
            let paceQuery = HKSampleQuery(sampleType: paceType, predicate: broaderPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, paceSamples, _ in
                guard let paceSamples = paceSamples as? [HKQuantitySample], !paceSamples.isEmpty else {
                    DispatchQueue.main.async {
                        completion(averageHeartRate, nil)
                    }
                    return
                }
                
                let paces = paceSamples.map { $0.quantity.doubleValue(for: HKUnit.meter().unitDivided(by: HKUnit.second())) }
                
                let averagePace: Double?
                if !paces.isEmpty {
                    let averageSpeed = paces.reduce(0, +) / Double(paces.count)
                    averagePace = averageSpeed > 0 ? (1 / averageSpeed) * 1000 / 60 : nil
                } else {
                    averagePace = nil
                }
                
                DispatchQueue.main.async {
                    completion(averageHeartRate, averagePace)
                }
            }
            
            self.store.execute(paceQuery)
        }
        
        store.execute(heartRateQuery)
    }
    
    func fetchStepCount(for workout: HKWorkout, completion: @escaping (Double?) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(nil)
                return
            }
            
            guard let sum = result?.sumQuantity() else {
                completion(nil)
                return
            }
            
            let stepCount = sum.doubleValue(for: HKUnit.count())
            completion(stepCount)
        }
        
        store.execute(query)
    }
}
