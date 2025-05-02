//
//  NewWorkoutView.swift
//  ItsukiWorkoutApp
//
//  Created by Itsuki on 2025/03/02.
//

import SwiftUI
import HealthKit

struct NewWorkoutView: View {
    @Environment(WorkoutManager.self) private var workoutManager
    @State private var vm = NewWorkoutViewModel()

    var body: some View {
        @Bindable var workoutManager = workoutManager
        let supportedWorkoutTypes = Array(workoutManager.supportedWorkoutTypes)
        List {
            if let error = workoutManager.error {
                Text(error.message)
                    .foregroundStyle(Color.fitnessRedMain)
            }
            
            ForEach(0..<supportedWorkoutTypes.count, id: \.self) { index in
                let workoutType = supportedWorkoutTypes[index]
                WorkoutTypeButton(workoutType: workoutType)
            }
        }
        .sheet(isPresented: $vm.showConfigurationSheet, content:  {
            WorkoutCongirurationSheet()
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
            vm.selectedWorkoutType = workoutType
            vm.showConfigurationSheet = true
        }, label: {
            Text(workoutType.string)
                .font(.title2)
        })
    }
    
    @ViewBuilder
    func WorkoutCongirurationSheet() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let selectedWorkoutType = vm.selectedWorkoutType {
                if selectedWorkoutType == .swimming {
                    List {
                        Picker(selection: $vm.swimLocation, content: {
                            Text("Открытая вода")
                                .tag(HKWorkoutSwimmingLocationType.openWater)
                            Text("Бассейн")
                                .tag(HKWorkoutSwimmingLocationType.pool)
                        }, label: {
                            Text("Локация плавания")
                        })
                    }
                    .frame(height: 56)
                    .scrollIndicators(.hidden)
                    .scrollDisabled(true)
                    
                    HStack {
                        Text("Длина дорожки (м)")
                            .padding(.leading, 4)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        TextField("", value: $vm.lapLength, format: .number)
                    }
                } else {
                    Form {
                        Picker(selection: $vm.activityLocation, content: {
                            Text("В помещении")
                                .tag(HKWorkoutSessionLocationType.indoor)
                            Text("На улице")
                                .tag(HKWorkoutSessionLocationType.outdoor)
                        }, label: {
                            Text("Локация активности")
                        })
                    }
                }
                
                if let error = workoutManager.error {
                    Text(error.message)
                        .foregroundStyle(Color.fitnessRedMain)
                        .padding(.leading, 4)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                HStack(spacing: 8) {
                    Button(action: {
                        vm.showConfigurationSheet = false
                    }, label: {
                        Text("Отмена")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .padding(.all, 4)
                            .background(Capsule().fill(Color.fitnessRedMain))
                            .contentShape(Rectangle())
                    })
                    
                    Button(action: {
                        Task {
                            let configuration = HKWorkoutConfiguration()
                            configuration.activityType = selectedWorkoutType
                            if selectedWorkoutType == .swimming {
                                configuration.swimmingLocationType = vm.swimLocation
                                configuration.lapLength = HKQuantity(unit: HKUnit.meter(), doubleValue: Double(vm.lapLength))
                            } else {
                                configuration.locationType = vm.activityLocation
                            }
                            await workoutManager.startWorkout(with: configuration)
                            vm.showConfigurationSheet = false
                        }
                    }, label: {
                        Text("Начать")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .padding(.all, 4)
                            .background(Capsule().fill(Color.fitnessGreenMain))
                            .contentShape(Rectangle())
                    })
                }
                .padding(.trailing, 4)
                .fontWeight(.semibold)
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .font(.system(size: 12))
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbarVisibility(.hidden, for: .navigationBar)
        .interactiveDismissDisabled()
    }
}

#Preview {
    let manager = WorkoutManager()
    let configuration = HKWorkoutConfiguration()
    configuration.activityType = .swimBikeRun
    
    return NavigationStack {
        NewWorkoutView()
            .environment(manager)
            .onAppear {
                manager.workoutMetrics = .init(workoutConfiguration: configuration)
            }
    }
}
