//
//  Date+Ext.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/11/25.
//

import Foundation

extension Date {
    // Временная зона для Москвы
    static var moscowTimeZone: TimeZone {
        return TimeZone(identifier: "Europe/Moscow")!
    }
    
    // Получение начала дня в московском времени
    static var startOfDay: Date {
        var calendar = Calendar.current
        calendar.timeZone = moscowTimeZone
        return calendar.startOfDay(for: Date())
    }
    
    // Получение начала недели в московском времени
    static var startOfWeek: Date {
        var calendar = Calendar.current
        calendar.timeZone = moscowTimeZone
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2 // Понедельник
        return calendar.date(from: components) ?? Date()
    }
    
    // Получение начала и конца месяца в московском времени
    func fetchMonthStartAndEndDate() -> (Date, Date) {
        var calendar = Calendar.current
        calendar.timeZone = Date.moscowTimeZone
        
        // Начало месяца
        let startDateComponent = calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self))
        let startDate = calendar.date(from: startDateComponent) ?? self
        
        // Конец месяца
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) ?? self
        return (startDate, endDate)
    }
    
    // Форматирование даты для отображения "Март 25"
    func formatWorkoutDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        formatter.timeZone = Date.moscowTimeZone // Устанавливаем временную зону
        return formatter.string(from: self)
    }
    
    // Форматирование даты понедельника недели
    func mondayDateFormat() -> String {
        let monday = Date.startOfWeek
        let formetter = DateFormatter()
        formetter.dateFormat = "MM-dd-yyyy"
        formetter.timeZone = Date.moscowTimeZone // Устанавливаем временную зону
        return formetter.string(from: monday)
    }
    
    // Форматирование даты с учетом компонента (например, день или месяц)
    static func formattedDate(from date: Date, unit: Calendar.Component) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = Date.moscowTimeZone // Устанавливаем временную зону
        switch unit {
        case .day:
            formatter.dateFormat = "EEEE" // Полное название дня недели (например, "Понедельник")
        case .month:
            formatter.dateFormat = "MMMM yyyy" // Месяц и год (например, "Март 2024")
        default:
            formatter.dateFormat = "LLLL" // Название месяца (например, "Март")
        }
        return formatter.string(from: date)
    }
}
