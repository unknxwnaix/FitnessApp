//
//  NewWorkoutView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 2025/03/02.
//

import SwiftUI
import HealthKit

struct NewWorkoutView: View {
    @Environment(WorkoutManager.self) private var workoutManager
    @State private var vm = NewWorkoutViewModel()
    @State private var isLoading = false

    var body: some View {
        @Bindable var workoutManager = workoutManager
        let supportedWorkoutTypes = Array(workoutManager.supportedWorkoutTypes)
        if let error = workoutManager.error {
            Text(error.message)
                .foregroundStyle(Color.fitnessRedMain)
        }
        
        if isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
        }
        
        ScrollView {
            ForEach(0..<supportedWorkoutTypes.count, id: \.self) { index in
                let workoutType = supportedWorkoutTypes[index]
                WorkoutTypeButton(workoutType: workoutType)
            }
        }
        .sheet(isPresented: $vm.showConfigurationSheet, content:  {
            WorkoutConfigurationSheetView(vm: vm)
                .environment(workoutManager)
        })
        .onChange(of: vm.showConfigurationSheet, {
            if !vm.showConfigurationSheet {
                vm.selectedWorkoutType = nil
            }
        })
        .onAppear {
            workoutManager.error = nil
        }
        .onDisappear {
            workoutManager.error = nil
        }
        .navigationTitle("Новая тренировка")
        .navigationDestination(item: $workoutManager.workoutMetrics, destination: { _ in
            WorkoutProgressView()
                .environment(workoutManager)
        })
        .sheet(isPresented: $workoutManager.showResult) {
            WorkoutResultView()
                .environment(workoutManager)
                .toolbarVisibility(.hidden, for: .navigationBar)
        }
    }
    
    @ViewBuilder
    func WorkoutTypeButton(workoutType: HKWorkoutActivityType) -> some View {
        Button(action: {
            Task {
                isLoading = true
                defer { isLoading = false }
                
                do {
                    vm.selectedWorkoutType = workoutType
                    vm.showConfigurationSheet = true
                } catch {
                    print("Error starting workout: \(error.localizedDescription)")
                    workoutManager.error = .startWorkoutFailed(error)
                }
            }
        }, label: {
            Text(workoutType.string)
                .font(.title3)
        })
        .disabled(isLoading)
        .tint(Color.fitnessGreenMain)
    }
}

#Preview {
    let manager = WorkoutManager()
    let configuration = HKWorkoutConfiguration()
    configuration.activityType = .swimBikeRun
    
    return NavigationStack {
        NewWorkoutView()
            .environment(manager)
//            .onAppear {
//                manager.workoutMetrics = .init(workoutConfiguration: configuration)
//            }
    }
}
