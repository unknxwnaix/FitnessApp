//
//  WorkoutDetail.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/21/25.
//

import SwiftUI

struct WorkoutDetail: Identifiable {
    let id = UUID()
    var title: String
    var image: String
    var tintColor: Color
    var duration: String
    var date: String
    var calories: String
    var averageHeartRate: String
    var distance: String
    var steps: String
    var pace: String
}

extension WorkoutDetail {
    static let mock = WorkoutDetail(
        title: "Прогулка",
        image: "figure.walk",
        tintColor: .fitnessGreenMain,
        duration: "45 мин",
        date: "20 апр",
        calories: "320 ккал",
        averageHeartRate: "105 уд/мин",
        distance: "3.2 км",
        steps: "4300 шагов",
        pace: "10 мин"
    )
}
