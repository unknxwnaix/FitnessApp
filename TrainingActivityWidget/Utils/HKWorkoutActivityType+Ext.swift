//
//  HKWorkoutActivityTypeName.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 2/3/25.
//

import HealthKit
import SwiftUI

extension HKWorkoutActivityType {

    /*
     Simple mapping of available workout types to a human readable name.
     */
    var name: String {
        switch self {
        case .americanFootball:             return "Американский футбол"
        case .archery:                      return "Стрельба из лука"
        case .australianFootball:           return "Австралийский футбол"
        case .badminton:                    return "Бадминтон"
        case .baseball:                     return "Бейсбол"
        case .basketball:                   return "Баскетбол"
        case .bowling:                      return "Боулинг"
        case .boxing:                       return "Бокс"
        case .climbing:                     return "Скалолазание"
        case .crossTraining:                return "Кросс-тренинг"
        case .curling:                      return "Кёрлинг"
        case .cycling:                      return "Велоспорт"
        case .dance:                        return "Танцы"
        case .danceInspiredTraining:        return "Танцевальная тренировка"
        case .elliptical:                   return "Эллиптический тренажёр"
        case .equestrianSports:             return "Конный спорт"
        case .fencing:                      return "Фехтование"
        case .fishing:                      return "Рыбалка"
        case .functionalStrengthTraining:   return "Функциональный тренинг"
        case .golf:                         return "Гольф"
        case .gymnastics:                   return "Гимнастика"
        case .handball:                     return "Гандбол"
        case .hiking:                       return "Поход"
        case .hockey:                       return "Хоккей"
        case .hunting:                      return "Охота"
        case .lacrosse:                     return "Лакросс"
        case .martialArts:                  return "Боевые искусства"
        case .mindAndBody:                  return "Разум и тело"
        case .mixedMetabolicCardioTraining: return "Смешанная метаболическая кардиотренировка"
        case .paddleSports:                 return "Гребные виды спорта"
        case .play:                         return "Игра"
        case .preparationAndRecovery:       return "Подготовка и восстановление"
        case .racquetball:                  return "Ракетбол"
        case .rowing:                       return "Гребля"
        case .rugby:                        return "Регби"
        case .running:                      return "Бег"
        case .sailing:                      return "Парусный спорт"
        case .skatingSports:                return "Катание на коньках"
        case .snowSports:                   return "Зимние виды спорта"
        case .soccer:                       return "Футбол"
        case .softball:                     return "Софбол"
        case .squash:                       return "Сквош"
        case .stairClimbing:                return "Подъём по лестнице"
        case .surfingSports:                return "Сёрфинг"
        case .swimming:                     return "Плавание"
        case .tableTennis:                  return "Настольный теннис"
        case .tennis:                       return "Теннис"
        case .trackAndField:                return "Лёгкая атлетика"
        case .traditionalStrengthTraining:  return "Традиционный силовой тренинг"
        case .volleyball:                   return "Волейбол"
        case .walking:                      return "Ходьба"
        case .waterFitness:                 return "Аквааэробика"
        case .waterPolo:                    return "Водное поло"
        case .waterSports:                  return "Водные виды спорта"
        case .wrestling:                    return "Борьба"
        case .yoga:                         return "Йога"
            
        // iOS 10
        case .barre:                        return "Барре"
        case .coreTraining:                 return "Тренировка корпуса"
        case .crossCountrySkiing:           return "Лыжные гонки"
        case .downhillSkiing:               return "Горные лыжи"
        case .flexibility:                  return "Гибкость"
        case .highIntensityIntervalTraining:return "Интервальная тренировка высокой интенсивности"
        case .jumpRope:                     return "Прыжки через скакалку"
        case .kickboxing:                   return "Кикбоксинг"
        case .pilates:                      return "Пилатес"
        case .snowboarding:                 return "Сноуборд"
        case .stairs:                       return "Лестница"
        case .stepTraining:                 return "Степ-тренировка"
        case .wheelchairWalkPace:           return "Ходьба в инвалидной коляске"
        case .wheelchairRunPace:            return "Бег в инвалидной коляске"
            
        // iOS 11
        case .taiChi:                       return "Тай-чи"
        case .mixedCardio:                  return "Смешанное кардио"
        case .handCycling:                  return "Ручной велосипед"
            
        // iOS 13
        case .discSports:                   return "Игры с летающим диском"
        case .fitnessGaming:                return "Фитнес-игры"
            
        // Catch-all
        default:                            return "Другое"
        }
    }
    
    var image: String {
           let symbolName: String
           switch self {
           case .americanFootball:             symbolName = "sportscourt"
           case .archery:                      symbolName = "archerytarget"
           case .australianFootball:           symbolName = "sportscourt"
           case .badminton:                    symbolName = "sportscourt"
           case .baseball:                     symbolName = "figure.baseball"
           case .basketball:                   symbolName = "figure.basketball"
           case .bowling:                      symbolName = "sportscourt"
           case .boxing:                       symbolName = "boxingglove"
           case .climbing:                     symbolName = "mountain"
           case .crossTraining:                symbolName = "figure.walk"
           case .curling:                      symbolName = "sportscourt"
           case .cycling:                      symbolName = "bicycle"
           case .dance:                        symbolName = "music.note"
           case .danceInspiredTraining:        symbolName = "music.note"
           case .elliptical:                   symbolName = "ellipsis.circle"
           case .equestrianSports:             symbolName = "horse"
           case .fencing:                      symbolName = "sportscourt"
           case .fishing:                      symbolName = "fish"
           case .functionalStrengthTraining:   symbolName = "figure.walk"
           case .golf:                         symbolName = "sportscourt"
           case .gymnastics:                   symbolName = "person"
           case .handball:                     symbolName = "sportscourt"
           case .hiking:                       symbolName = "map"
           case .hockey:                       symbolName = "sportscourt"
           case .hunting:                      symbolName = "cross"
           case .lacrosse:                     symbolName = "sportscourt"
           case .martialArts:                  symbolName = "sportscourt"
           case .mindAndBody:                  symbolName = "yoga"
           case .mixedMetabolicCardioTraining: symbolName = "figure.walk"
           case .paddleSports:                 symbolName = "canoe"
           case .play:                         symbolName = "gamecontroller"
           case .preparationAndRecovery:       symbolName = "wrench"
           case .racquetball:                  symbolName = "sportscourt"
           case .rowing:                       symbolName = "rowing"
           case .rugby:                        symbolName = "sportscourt"
           case .running:                      symbolName = "figure.walk"
           case .sailing:                      symbolName = "sailboat"
           case .skatingSports:                symbolName = "skating"
           case .snowSports:                   symbolName = "snow"
           case .soccer:                       symbolName = "sportscourt"
           case .softball:                     symbolName = "sportscourt"
           case .squash:                       symbolName = "sportscourt"
           case .stairClimbing:                symbolName = "figure.stairs"
           case .surfingSports:                symbolName = "sportscourt"
           case .swimming:                     symbolName = "figure.pool.swim"
           case .tableTennis:                  symbolName = "sportscourt"
           case .tennis:                       symbolName = "sportscourt"
           case .trackAndField:                symbolName = "sportscourt"
           case .traditionalStrengthTraining:  symbolName = "figure.strengthtraining.traditional"
           case .volleyball:                   symbolName = "sportscourt"
           case .walking:                      symbolName = "figure.walk"
           case .waterFitness:                 symbolName = "drop.triangle"
           case .waterPolo:                    symbolName = "sportscourt"
           case .waterSports:                  symbolName = "sportscourt"
           case .wrestling:                    symbolName = "sportscourt"
           case .yoga:                         symbolName = "lotus"

           // iOS 10
           case .barre:                        symbolName = "sportscourt"
           case .coreTraining:                 symbolName = "figure.walk"
           case .crossCountrySkiing:           symbolName = "skis"
           case .downhillSkiing:               symbolName = "skis"
           case .flexibility:                  symbolName = "sportscourt"
           case .highIntensityIntervalTraining:    symbolName = "figure.strengthtraining.traditional"
           case .jumpRope:                     symbolName = "sportscourt"
           case .kickboxing:                   symbolName = "figure.kickboxing"
           case .pilates:                      symbolName = "sportscourt"
           case .snowboarding:                 symbolName = "snow"
           case .stairs:                       symbolName = "figure.stairs"
           case .stepTraining:                 symbolName = "sportscourt"
           case .wheelchairWalkPace:           symbolName = "figure.walk"
           case .wheelchairRunPace:            symbolName = "figure.walk"

           // iOS 11
           case .taiChi:                       symbolName = "sportscourt"
           case .mixedCardio:                  symbolName = "figure.walk"
           case .handCycling:                  symbolName = "sportscourt"

           // iOS 13
           case .discSports:                   symbolName = "sportscourt"
           case .fitnessGaming:                symbolName = "sportscourt"

           // Catch-all
           default:                            symbolName = "questionmark"
           }

           return symbolName
       }

    var color: Color {
        let defaultColor = Color.black // Set a default color in case there's no specific mapping

        switch self {
        case .running, .cycling, .hiking, .walking:
            return Color.fitnessGreenMain
        case .swimming, .waterFitness, .waterPolo, .waterSports:
            return Color.teal
        case .yoga, .mindAndBody, .pilates:
            return Color.fitnessGreenMain
        case .climbing, .functionalStrengthTraining, .traditionalStrengthTraining:
            return Color.blue
        case .boxing, .martialArts, .wrestling:
            return Color.red
        case .dance, .danceInspiredTraining:
            return Color.purple
        case .rowing:
            return Color.yellow
        case .snowboarding:
            return Color.indigo
        case .elliptical, .stairClimbing:
            return Color.pink
        case .golf:
            return Color.fitnessGreenMain
        case .tennis, .tableTennis:
            return Color.orange
        case .baseball, .basketball, .soccer, .volleyball:
            return Color.red
        case .badminton, .racquetball, .squash:
            return Color.pink
        case .crossCountrySkiing, .downhillSkiing:
            return Color.indigo
        case .surfingSports, .snowSports:
            return Color.teal
        case .hockey:
            return Color.red
        case .skatingSports:
            return Color.purple
        case .equestrianSports:
            return Color.brown
        case .fishing, .hunting:
            return Color.gray
        case .handball, .lacrosse:
            return Color.pink
        case .play, .preparationAndRecovery:
            return Color.yellow
        case .discSports, .fitnessGaming:
            return Color.fitnessGreenMain
        case .mixedMetabolicCardioTraining, .mixedCardio, .highIntensityIntervalTraining:
            return Color.orange
        case .coreTraining, .stepTraining, .jumpRope, .barre, .flexibility:
            return Color.pink
        case .wheelchairWalkPace, .wheelchairRunPace, .handCycling:
            return Color.blue

        // Catch-all
        default:
            return defaultColor
        }
    }
}
