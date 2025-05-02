//
//  HomeView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack (alignment: .leading) {
                    HeaderView()
                                        
                    if !vm.activities.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
                            
                            Section {
                                ForEach(vm.activities, id: \.id) { activity in
                                    ActivityCardView(activity: activity)
                                }
                            } header: {
                                HeaderOfSection(title: "Фитнес активность")
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    
                    if !vm.workouts.isEmpty {
                        LazyVStack {
                            Section {
                                ForEach(vm.workouts, id: \.id) { workout in
                                    WorkoutCardView(workout: workout)
                                }
                            } header: {
                                HeaderOfSection(title: "Последние тренировки")
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Главная")
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 0.9)) {
                        vm.caloriesDisplay = vm.calories
                        vm.exerciseDisplay = vm.exercise
                        vm.standDisplay = vm.stand
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            ActivityProgressCircles()
            
            Spacer()
            
            VStack(alignment: .leading) {
                ActivityValue(title: "Подвижность", value: "\(vm.caloriesDisplay)", unit: "ккал.", tint: .fitnessRedMain)
                
                
                ActivityValue(title: "Упражнения", value: "\(vm.exerciseDisplay)", unit: "мин.", tint: .fitnessGreenMain)
                
                ActivityValue(title: "Стоя", value: "\(vm.stand)", unit: "ч.", tint: .fitnessBlueMain)
                
            }
            .padding(.leading, 5)
            
            Spacer()
        }
        .padding(.trailing)

    }
    
    @ViewBuilder
    func ActivityProgressCircles() -> some View {
        ZStack {
            ProgressCircleView(
                progress: $vm.caloriesDisplay,
                goal: vm.caloriesGoal,
                colorMain: .fitnessRedMain,
                colorTail: .fitnessRedTail,
                imageName: "flame.fill"
            )
            
            ProgressCircleView(
                progress: $vm.exerciseDisplay,
                goal: vm.activityGoal,
                colorMain: .fitnessGreenMain,
                colorTail: .fitnessGreenTail,
                imageName: "figure.run"
            )
            .padding(22)
            
            ProgressCircleView(
                progress: $vm.standDisplay,
                goal: vm.standGoal,
                colorMain: .fitnessBlueMain,
                colorTail: .fitnessBlueTail,
                imageName: "arrow.triangle.merge"
            )
            .padding(44)
        }
        .frame(width: 220, height: 220)
        .shadow(radius: 5, x: 3, y: 3)
        .padding(.horizontal)
        .padding(.top)
    }
    
    @ViewBuilder
    func ActivityValue(title: String, value: String, unit: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.callout)
                .bold()
                .foregroundStyle(tint)
            
            HStack {
                Text(value)
                    .bold()
                    .font(.title)
                    .fontDesign(.rounded)
                Text(unit)
                    .bold()
                    .font(.callout)
                    .fontDesign(.rounded)
            }
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    func HeaderOfSection(title: String) -> some View {
        HStack {
            Text(title)
                .font(.title.bold())
            
            Spacer()
        }
        .padding(.vertical)
    }
}



#Preview {
    HomeView()
}
