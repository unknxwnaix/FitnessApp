//
//  ContentView.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/21/25.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ZStack {
                        ProgressCircleView(progress: $vm.caloriesDisplay, goal: vm.caloriesGoal, colorMain: .fitnessRedMain, colorTail: .fitnessRedTail, imageName: "flame.fill")
                        
                        ProgressCircleView(progress: $vm.exerciseDisplay, goal: vm.activityGoal, colorMain: .fitnessGreenMain, colorTail: .fitnessGreenTail, imageName: "figure.run")
                            .padding(.horizontal, 22)
                        
                        ProgressCircleView(progress: $vm.standDisplay, goal: vm.standGoal, colorMain: .fitnessBlueMain, colorTail: .fitnessBlueTail, imageName: "arrow.triangle.merge")
                            .padding(44)
                    }
                    .frame(width: 150, height: 150)
                    .padding(.top, 15)
                    
                    VStack(spacing: 5) {
                        ActivityLineView( title: "Calories", value: $vm.caloriesDisplay, color: vm.caloriesColor, goal: vm.caloriesGoal)
                        
                        ActivityLineView( title: "Activity", value: $vm.exerciseDisplay, color: vm.activityColor, goal: vm.activityGoal)
                        
                        ActivityLineView( title: "Stand", value: $vm.standDisplay, color: vm.standColor, goal: vm.standGoal)
                    }
                    
                    
                }
            }
            .navigationTitle("Активность")
        }
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

#Preview {
    HomeView()
}
