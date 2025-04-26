//
//  ChartDataView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/9/25.
//

import SwiftUI
import Charts

struct ChartDataView: View {
    @State var chartData: ChartData
    @State private var rawSelectedDate: Date?
    
    var selectedStep: (any Step)? {
        guard let rawSelectedDate else { return nil }
        
        return chartData.data.first(where: { step in
            Calendar.current.isDate(step.date, equalTo: rawSelectedDate, toGranularity: chartData.unit)
        })
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                VStack(spacing: 16) {
                    Text("Среднее")
                        .font(.title2)
                    
                    Text("\(chartData.average)")
                        .font(.title3)
                }
                .foregroundStyle(.white)
                .frame(width: 90, height: 65)
                .padding()
                .background(.gray.opacity(0.15))
                .cornerRadius(15)
                .frame(width: 90, height: 65)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Text("Всего")
                        .font(.title2)
                    
                    Text("\(chartData.total)")
                        .font(.title3)
                }
                .foregroundStyle(.white)
                .frame(width: 90, height: 65)
                .padding()
                .background(.gray.opacity(0.15))
                .cornerRadius(15)
                
                
                Spacer()
            }
            .opacity(rawSelectedDate == nil ? 1 : 0)
            
            Chart {
                if let selectedStep {
                    RuleMark(x: .value("Selected Date", selectedStep.date, unit: chartData.unit))
                        .foregroundStyle(.green.opacity(0.3))
                        .annotation(position: .top,  overflowResolution: .init(x: .fit(to: .plot), y: .disabled)) {
                            VStack(spacing: 10) {
                                Text("\(Date.formattedDate(from: selectedStep.date, unit: chartData.unit))")
                                    .font(.title2)
                                    .contentTransition(.symbolEffect)
                                
                                Text("\(selectedStep.count)")
                                    .font(.system(size: 30, weight: .bold, design: .rounded))
                                    .contentTransition(.numericText())
                            }
                            .foregroundStyle(.white)
                            .padding(12)
                            .frame(width: 200, height: 105)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .fill(.green.gradient)
                            )
                        }
                }
                
                ForEach(chartData.data, id: \.id) { data  in
                    BarMark(x: .value(data.date.formatted(), data.date, unit: chartData.unit), y: .value("Steps", data.count ))
                        .foregroundStyle(.green)
                        .opacity(rawSelectedDate == nil || data.date == selectedStep?.date ? 0.9 : 0.3)
                }
                
                RuleMark(y: .value("AVG", chartData.average))
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                    .annotation {
                        Text("Среднее")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                            .foregroundStyle(.white)
                            .font(.caption)
                            .padding(5)
                            .background(.gray)
                            .cornerRadius(10)
                    }
                    .foregroundStyle(.gray)
            }
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
        }
    }
}

#Preview {
    ChartDataView(chartData: ChartData(data: DailyStepModel.generate(forDays: 30), average: 10000, total: 100000, unit: .day))
}
