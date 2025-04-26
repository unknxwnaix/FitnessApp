//
//  Page.swift
//  IntroApp
//
//  Created by Maxim Dmitrochenko on 4/23/25.
//

import SwiftUI

enum Page: String, CaseIterable {
    case page1 = "heart.fill"
    case page2 = "chart.bar.xaxis.ascending.badge.clock"
    case page3 = "applewatch"
    case page4 = "medal"
    case page5 = "arrow.turn.right.down"
    
    var title: String {
        switch self {
        case .page1:
            return "Добро пожаловать в Fitness App!"
        case .page2:
            return "Множество графиков"
        case .page3:
            return "Приложение на Apple Watch"
        case .page4:
            return "Списки лидеров"
        case .page5:
            return "Опробуй все возможности Сам!"
        }
    }
    
    var subTitle: String {
        switch self {
        case .page1:
            return "Новое приложение, которое позволяет Вам отслеживать метрики и параметры, связанные со здоровьем"
        case .page2:
            return "Данные о калориях, шагах и тренировках теперь в удобном визуальном формате!"
        case .page3:
            return "На часах будет не только дублироваться информация, но будут и свои \"уникальные\" метрики!"
        case .page4:
            return "Стань лидером в еженедельном списке!"
        case .page5:
            return "Жми кнопку снизу"
        }
    }
    
    var index: CGFloat {
        switch self {
        case .page1:
            return 0
        case .page2:
            return 1
        case .page3:
            return 2
        case .page4:
            return 3
        case .page5:
            return 4
        }
    }

    /// Возвращает следующую страницу, если это не последняя страница
    var nextPage: Page {
        let index = Int(self.index) + 1
        if index < 5 {
            return Page.allCases[index]
        }
        return self
    }

    /// Возвращает предыдущую страницу, если это не первая страница
    var previousPage: Page {
        let index = Int(self.index) - 1
        if index >= 0 {
            return Page.allCases[index]
        }
        return self
    }
}
