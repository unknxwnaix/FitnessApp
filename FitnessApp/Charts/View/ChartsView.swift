//
//  ChartsView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/9/25.
//

import SwiftUI
import Charts

struct ChartData {
    let data: [any Step]
    let average: Int
    let total: Int
    let unit: Calendar.Component
}

struct ChartsView: View {
    @StateObject var vm = ChartsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    switch vm.selectedChart {
                    case .oneWeek:
                        ChartDataView(chartData: ChartData(data: vm.oneWeekChartData, average: vm.oneWeekAverage, total: vm.oneWeekTotal, unit: .day))
                    case .oneMonth:
                        ChartDataView(chartData: ChartData(data: vm.oneMonthChartData, average: vm.oneMonthAverage, total: vm.oneMonthTotal, unit: .day))
                    case .threeMonths:
                        ChartDataView(chartData: ChartData(data: vm.threeMonthChartData, average: vm.threeMonthAverage, total: vm.threeMonthTotal, unit: .day))
                    case .yearToDate:
                        ChartDataView(chartData: ChartData(data: vm.ytdChartData, average: vm.ytdAverage, total: vm.ytdTotal, unit: .month))
                    case .oneYear:
                        ChartDataView(chartData: ChartData(data: vm.oneYearChartData, average: vm.oneYearAverage, total: vm.oneYearTotal, unit: .month))
                    }
                }
                .frame(height: 450)
                .foregroundStyle(.green)
                .padding(.horizontal)
                
                HStack {
                    ForEach(ChartOptions.allCases, id: \.rawValue) { option in
                        Button(option.rawValue) {
                            withAnimation(.easeInOut) {
                                vm.selectedChart = option
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(vm.selectedChart == option ? .green : .white)
                    }
                }
            }
            .navigationTitle("Графики")
        }
    }
}

#Preview {
    ChartsView()
}
