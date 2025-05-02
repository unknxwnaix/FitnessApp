//
//  WorkoutConfigurationSheetView.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 5/2/25.
//

import SwiftUI
import HealthKit

struct WorkoutConfigurationSheetView: View {
    @Bindable var vm: NewWorkoutViewModel
    @Environment(WorkoutManager.self) private var workoutManager
    @State private var isLoading = false
    
    var body: some View {
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
                        .font(.caption2)
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
                            .font(.caption2)
                    }
                } else {
                    List {
                        Picker(selection: $vm.activityLocation, content: {
                            Text("В помещении")
                                .tag(HKWorkoutSessionLocationType.indoor)
                            Text("На улице")
                                .tag(HKWorkoutSessionLocationType.outdoor)
                        }, label: {
                            Text("Локация активности")
                        })
                        .font(.caption2)
                    }
                    .scrollIndicators(.hidden)
                    .scrollDisabled(true)
                }
                
                if let error = workoutManager.error {
                    Text(error.message)
                        .foregroundStyle(Color.fitnessRedMain)
                        .padding(.leading, 4)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                Spacer(minLength: 0)
                
                HStack {
                    Button(action: {
                        vm.showConfigurationSheet = false
                        vm.selectedWorkoutType = nil
                        vm.activityLocation = .outdoor
                        vm.swimLocation = .pool
                        vm.lapLength = 400
                    }, label: {
                        Text("Отмена")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .padding(.all, 4)
                            .background(Capsule().fill(Color.fitnessRedMain))
                            .contentShape(Rectangle())
                    })
                    .disabled(isLoading)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            isLoading = true
                            defer { isLoading = false }
                            
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
                        ZStack {
                            if isLoading {
                                ProgressView()
                                    .tint(Color.fitnessGreenMain)
                                    .frame(width: 10, height: 10)
                            }
                            Text("Начать")
                                .opacity(isLoading ? 0 : 1)
                        }
                    })
                    .font(.title3)
                    .foregroundStyle(.white)
                    .padding(.all, 4)
                    .background(Capsule().fill(Color.fitnessGreenMain.opacity(isLoading ? 0.35 : 1)))
                    .contentShape(Rectangle())
                    .disabled(isLoading)
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
    
    return NavigationStack {
        NewWorkoutView()
            .environment(manager)
    }
}
