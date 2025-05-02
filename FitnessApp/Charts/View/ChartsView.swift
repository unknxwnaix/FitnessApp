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
    @State private var currentChartID = UUID()
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    if vm.isLoading {
                        CustomProgressView()
                    } else if !vm.isDataLoaded {
                        CustomProgressView()
                    } else {
                        switch vm.selectedChart {
                        case .oneWeek:
                            ChartDataView(chartData: ChartData(data: vm.oneWeekChartData, average: vm.oneWeekAverage, total: vm.oneWeekTotal, unit: .day))
                                .id(currentChartID)
                        case .oneMonth:
                            ChartDataView(chartData: ChartData(data: vm.oneMonthChartData, average: vm.oneMonthAverage, total: vm.oneMonthTotal, unit: .day))
                                .id(currentChartID)
                        case .threeMonths:
                            ChartDataView(chartData: ChartData(data: vm.threeMonthChartData, average: vm.threeMonthAverage, total: vm.threeMonthTotal, unit: .day))
                                .id(currentChartID)
                        case .yearToDate:
                            ChartDataView(chartData: ChartData(data: vm.ytdChartData, average: vm.ytdAverage, total: vm.ytdTotal, unit: .month))
                                .id(currentChartID)
                        case .oneYear:
                            ChartDataView(chartData: ChartData(data: vm.oneYearChartData, average: vm.oneYearAverage, total: vm.oneYearTotal, unit: .month))
                                .id(currentChartID)
                        }
                    }
                }
                .frame(height: 450)
                .foregroundStyle(Color.fitnessGreenMain)
                .padding(.horizontal)
                
                HStack {
                    ForEach(ChartOption.allCases, id: \.rawValue) { option in
                        ChartOptionButton(option: option)
                    }
                }
            }
            .navigationTitle("Графики")
        }
    }
    
    @ViewBuilder
    func ChartOptionButton(option: ChartOption) -> some View {
        Button(option.rawValue) {
            if vm.selectedChart != option {
                withAnimation {
                    currentChartID = UUID()
                    vm.selectedChart = option
                }
            }
        }
        .buttonStyle(.bordered)
        .tint(vm.selectedChart == option ? Color.fitnessGreenMain : .white)
    }
    
    @ViewBuilder
    func CustomProgressView() -> some View {
        ProgressView()
            .scaleEffect(2)
            .tint(Color.fitnessGreenMain)
            .padding(18)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.primary.opacity(0.2))
            }
    }
}

#Preview {
    ChartsView()
}
