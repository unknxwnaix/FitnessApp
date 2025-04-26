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
                    HStack {
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
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Подвижность")
                                    .font(.callout)
                                
                                    .bold()
                                    .foregroundStyle(.pink)
                                
                                HStack {
                                    Text("\(vm.caloriesDisplay)")
                                        .bold()
                                        .font(.title)
                                        .fontDesign(.rounded)
                                    Text("ккал.")
                                        .bold()
                                        .font(.callout)
                                        .fontDesign(.rounded)
                                }
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Упражнения")
                                    .font(.callout)
                                    .bold()
                                    .foregroundStyle(.green)
                                
                                HStack {
                                    Text("\(vm.exerciseDisplay)")
                                        .bold()
                                        .font(.title)
                                        .fontDesign(.rounded)
                                    Text("мин.")
                                        .bold()
                                        .font(.callout)
                                        .fontDesign(.rounded)
                                }
                            }
                            .padding(.bottom)
                            
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Стоя")
                                    .font(.callout)
                                    .bold()
                                    .foregroundStyle(.mint)
                                
                                HStack {
                                    Text("\(vm.stand)")
                                        .bold()
                                        .font(.title)
                                        .fontDesign(.rounded)
                                    Text("ч.")
                                        .bold()
                                        .font(.callout)
                                        .fontDesign(.rounded)
                                }
                            }
                            .padding(.bottom)
                            
                        }
                        .padding(.leading, 5)
                        
                        Spacer()
                    }
                    .padding(.trailing)
                    
                    if !vm.activities.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing:10), count: 2)) {
                            
                            Section {
                                ForEach(vm.activities, id: \.id) { activity in
                                    ActivityCardView(activity: activity)
                                }
                            } header: {
                                HStack {
                                    Text("Фитнес активность")
                                        .font(.title2)
                                    
                                    Spacer()
                                    
                                    //                                    NavigationLink {
                                    //                                        EmptyView()
                                    //                                    } label: {
                                    //                                        Text("Show More")
                                    //                                    }
                                    //                                    .buttonStyle(.bordered)
                                    //                                    .tint(.green)
                                }
                                .padding(.vertical)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    
                    LazyVStack {
                        Section {
                            ForEach(vm.workouts, id: \.id) { workout in
                                WorkoutCardView(workout: workout)
                            }
                        } header: {
                            HStack {
                                Text("Последние тренировки")
                                    .font(.title2)
                                
                                Spacer()
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
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
}

#Preview {
    HomeView()
}
