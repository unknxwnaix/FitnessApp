//
//  DailyStepModel.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/9/25.
//

import Foundation

protocol Step: Identifiable {
    var id: UUID { get }
    var date: Date { get set }
    var count: Int { get set }
}

struct MonthlyStepModel: Step {
    var id: UUID = UUID()
    var date: Date
    var count: Int
}

struct DailyStepModel: Step {
    var id: UUID = UUID()
    var date: Date
    var count: Int
}

extension MonthlyStepModel {
    static func generate(forMonth months: Int) -> [MonthlyStepModel] {
        let calendar = Calendar.current
        return (0..<months).map { i in
            let date = calendar.date(byAdding: .month, value: -i, to: Date()) ?? Date()
            return MonthlyStepModel (date: date, count: Int.random(in: 2000...15000))
        }
    }
}

extension DailyStepModel {
    static func generate(forDays days: Int) -> [DailyStepModel] {
        let calendar = Calendar.current
        return (0..<days).map { i in
            let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            return DailyStepModel (date: date, count: Int.random(in: 2000...15000))
        }
    }
}
