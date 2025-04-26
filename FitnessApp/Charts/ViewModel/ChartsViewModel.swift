//
//  ChartsViewModel.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/9/25.
//

import Foundation

class ChartsViewModel: ObservableObject {
    var mockChartData = DailyStepModel.generate(forDays: 7)
    var mockOneMonthChartData = DailyStepModel.generate(forDays: 30)
    var mockThreeMonthsChartData = DailyStepModel.generate(forDays: 90)
    var mockYTDChartData = MonthlyStepModel.generate(forMonth: 4)
    var mockOneYearChartData = MonthlyStepModel.generate(forMonth: 12)
    
    @Published var oneWeekChartData = [DailyStepModel]()
    @Published var oneWeekAverage = 0
    @Published var oneWeekTotal = 0
    
    @Published var oneMonthChartData = [DailyStepModel]()
    @Published var oneMonthAverage = 0
    @Published var oneMonthTotal = 0
    
    @Published var threeMonthChartData = [DailyStepModel]()
    @Published var threeMonthAverage = 0
    @Published var threeMonthTotal = 0
    
    @Published var ytdChartData = [MonthlyStepModel]()
    @Published var ytdAverage = 0
    @Published var ytdTotal = 0
    
    @Published var oneYearChartData = [MonthlyStepModel]()
    @Published var oneYearAverage = 0
    @Published var oneYearTotal = 0
    
    let healthManager = HealthManager.shared
    
    init() {
        fetchYTDAndOneYearData()
        fetchThreeMonthData()
    }
    
    @Published var selectedChart: ChartOptions = .oneWeek
    
    func fetchYTDAndOneYearData() {
        healthManager.fetchYTDAndOneYearData { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.ytdChartData = result.ytd
                    self.oneYearChartData = result.oneYear
                    
                    self.ytdTotal = self.ytdChartData.reduce(0) { $0 + $1.count }
                    self.oneYearTotal = self.oneYearChartData.reduce(0) { $0 + $1.count }
                    
                    self.ytdAverage = self.ytdTotal / Calendar.current.component(.month, from: Date())
                    self.oneYearAverage = self.oneYearTotal / 12
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchThreeMonthData() {
        healthManager.fetchThreeMonthStepData { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.oneWeekChartData = result.oneWeek
                    self.oneMonthChartData = result.oneMonth
                    self.threeMonthChartData = result.threeMonths
                    
                    self.oneWeekTotal = self.oneWeekChartData.reduce(0) { $0 + $1.count }
                    self.oneMonthTotal = self.oneMonthChartData.reduce(0) { $0 + $1.count }
                    self.threeMonthTotal = self.threeMonthChartData.reduce(0) { $0 + $1.count }
                    
                    self.oneWeekAverage = self.oneWeekTotal / 7
                    self.oneMonthAverage = self.oneMonthTotal / 30
                    self.threeMonthAverage = self.threeMonthTotal / 90
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
