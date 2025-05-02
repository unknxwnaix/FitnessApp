//
//  HKWorkoutActivityType+Utils.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 2025/03/03.
//

import HealthKit

extension HKWorkoutActivityType {

    var string: String {
        switch self {
        case .walking:
            return "Прогулка"
        case .running:
            return "Бег"
        case .cycling:
            return "Велосипед"
        case .swimming:
            return "Плавание"
        case .swimBikeRun:
            return "Триатлон"
        case .highIntensityIntervalTraining:
            return "Интервальная тренировка"
        case .transition:
            return "Переход"
        default:
            return "(не поддерживается)"
        }
    }
}
