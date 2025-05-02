//
//  WorkoutProgressView.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/26/25.
//

import SwiftUI
import HealthKit

struct WorkoutProgressView: View {
    @Environment(WorkoutManager.self) private var workoutManager
    @StateObject private var vm: WorkoutProgressViewModel

    init() {
        _vm = StateObject(wrappedValue: WorkoutProgressViewModel(workoutManager: WorkoutManager()))
    }
    
    var body: some View {
        ZStack {
            if vm.showProgressView {
                ProgressView()
                    .controlSize(.extraLarge)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
            
            if let metrics = workoutManager.workoutMetrics {
                VStack(alignment: .leading) {
                    HStack {
                        Text(workoutManager.getElapseTime(at: vm.currentDate).hourMinuteSecond)
                            .font(.title)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        Spacer()
                        
                        MenuButton()
                        .tint(.fitnessGreenMain)
                        .overlay(alignment: .top) {
                            if vm.showControl {
                                ControlButtons()
                            }
                        }
                        .overlay(alignment: .trailing) {
                            if vm.showControl {
                                ControlIntervalOptions(metrics: metrics)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    
                    TrainingStatistics(metrics: metrics)
                }
                .onReceive(vm.timer) { input in
                    vm.currentDate = input
                }
                .sheet(isPresented: $vm.showNewSubActivitySheet) {
                    SubActivitySheet(metrics: metrics)
                }
                .sheet(isPresented: $vm.showConfigurationSheet) {
                    ConfigurationSheet()
                }
                .disabled(vm.showProgressView)
                .navigationTitle("\(metrics.workoutConfiguration.activityType.string)")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            vm.showControl = false
        }
        .onAppear {
            workoutManager.error = nil
        }
        .onDisappear {
            workoutManager.error = nil
        }
    }
    
    @ViewBuilder
    func ConfigurationSheet() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let selectedWorkoutType = vm.selectedWorkoutType {
                if vm.selectedWorkoutType == .swimming {
                    List {
                        Picker(selection: $vm.swimLocation) {
                            Text("Открытая вода").tag(HKWorkoutSwimmingLocationType.openWater)
                            Text("Бассейн").tag(HKWorkoutSwimmingLocationType.pool)
                        } label: {
                            Text("Тип плавания")
                        }
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
                        Picker(selection: $vm.activityLocation) {
                            Text("В помещении").tag(HKWorkoutSessionLocationType.indoor)
                            Text("На улице").tag(HKWorkoutSessionLocationType.outdoor)
                        } label: {
                            Text("Место тренировки")
                        }
                    }
                }
                
                if let error = workoutManager.error {
                    Text(error.message)
                        .foregroundStyle(Color.fitnessRedMain)
                        .padding(.leading, 4)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                HStack {
                    Button(action: {
                        vm.showConfigurationSheet = false
                        vm.showNewSubActivitySheet = true
                    }, label: {
                        Text("Отмена")
                            .foregroundStyle(Color.fitnessRedMain)
                            .padding(4)
                            .contentShape(Rectangle())
                    })
                    .tint(.fitnessGreenMain)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            let configuration = HKWorkoutConfiguration()
                            configuration.activityType = selectedWorkoutType
                            if vm.selectedWorkoutType == .swimming {
                                configuration.swimmingLocationType = vm.swimLocation
                                configuration.lapLength = HKQuantity(unit: HKUnit.meter(), doubleValue: Double(vm.lapLength))
                            } else {
                                configuration.locationType = vm.activityLocation
                            }
                            await workoutManager.beginNewSubActivity(with: configuration)
                            vm.showConfigurationSheet = false
                            if workoutManager.error != nil {
                                vm.showNewSubActivitySheet = true
                            } else {
                                vm.showControl = false
                            }
                        }
                    }, label: {
                        Text("Начать")
                            .foregroundStyle(.blue)
                            .padding(4)
                            .contentShape(Rectangle())
                    })
                    .tint(.fitnessGreenMain)
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
    
    @ViewBuilder
    func SubActivitySheet(metrics: WorkoutManager.WorkoutMetrics) -> some View {
        List {
            if let error = workoutManager.error {
                Text(error.message)
                    .foregroundStyle(Color.fitnessRedMain)
            }
            
            let activityTypes = vm.getAllowedSubActivities()
            
            ForEach(0..<activityTypes.count, id: \.self) { index in
                let workoutType = activityTypes[index]
                Button(action: {
                    if workoutType == .transition {
                        let configuration = HKWorkoutConfiguration()
                        configuration.activityType = .transition
                        configuration.locationType = metrics.workoutConfiguration.locationType
                        Task {
                            await workoutManager.beginNewSubActivity(with: configuration)
                            if workoutManager.error == nil {
                                vm.showNewSubActivitySheet = false
                                vm.showControl = false
                            }
                        }
                        return
                    }
                    
                    vm.selectedWorkoutType = workoutType
                    vm.showNewSubActivitySheet = false
                    vm.showConfigurationSheet = true
                }, label: {
                    Text(workoutType.string)
                })
                .tint(.fitnessGreenMain)
            }
        }
    }
    
    @ViewBuilder
    func MenuButton() -> some View {
        Button(action: {
            withAnimation {
                vm.showControl.toggle()
            }
        }, label: {
            Image(systemName: "ellipsis")
                .rotationEffect(.degrees(vm.showControl ? 270 : 0))
                .frame(width: 32, height: 32)
                .background(Circle().fill(.gray))
        })
    }
    
    @ViewBuilder
    func ControlButtons() -> some View {
        let sessionRunning = workoutManager.sessionRunning
        VStack(spacing: 8) {
            Button(action: {
                sessionRunning ? workoutManager.pauseSession() : workoutManager.resumeSession()
            }, label: {
                Image(systemName: sessionRunning ? "pause.fill" : "arrow.clockwise")
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(.orange))
            })
            .tint(.fitnessGreenMain)
            
            Button(action: {
                workoutManager.endSession()
                vm.showProgressView = true
            }, label: {
                Image(systemName: "stop.fill")
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(Color.fitnessRedMain))
            })
            .tint(.fitnessGreenMain)
        }
        .padding(.top, 40)
    }
    
    @ViewBuilder
    func ControlIntervalOptions(metrics: WorkoutManager.WorkoutMetrics) -> some View {
        if metrics.subActivityConfiguration != nil && metrics.workoutConfiguration.activityType != .swimBikeRun {
            Button(action: {
                Task {
                    await workoutManager.endSubActivity()
                    vm.showControl = false
                }
            }, label: {
                Text("Закончить интервал")
                    .font(.system(size: 12))
                    .frame(width: 108, height: 32)
                    .background(Capsule().fill(Color.fitnessRedMain))
            })
            .padding(.trailing, 40)
            .tint(.fitnessGreenMain)
        } else {
            Button(action: {
                if metrics.workoutConfiguration.activityType == .swimBikeRun {
                    vm.showNewSubActivitySheet = true
                    return
                }
                
                Task {
                    await workoutManager.beginNewSubActivity(with: metrics.workoutConfiguration)
                    if workoutManager.error == nil {
                        vm.showControl = false
                    }
                }
            }, label: {
                Text(metrics.workoutConfiguration.activityType == .swimBikeRun ? "Новая суб-активность" : "Новый интервал")
                    .font(.system(size: 12))
                    .frame(width: 108, height: 32)
                    .background(Capsule().fill(Color.fitnessGreenMain))
            })
            .padding(.trailing, 40)
        }
    }
    
    @ViewBuilder
    func TrainingStatistics(metrics: WorkoutManager.WorkoutMetrics) -> some View {
        VStack(alignment: .leading, spacing: -3) {
            if let subActivity = metrics.subActivityConfiguration {
                HStack(spacing: 6) {
                    Image(systemName: "figure.walk")
                        .foregroundColor(.blue)
                    Text(subActivity.activityType.string)
                        .font(.system(size: 14))
                        .opacity(0.7)
                }
                .padding(.bottom, 4)
            }
            
            HStack(spacing: 6) {
                Image(systemName: "ruler")
                    .foregroundColor(Color.fitnessGreenMain)
                    .font(.system(size: 25))
                    .frame(width: 35)
                Text(metrics.distance.formatted(.number.precision(.fractionLength(0))) + " \(HKStatistics.distanceUnit.unitString)")
                    .font(.system(size: 30, design: .rounded))
                    .fontWeight(.semibold)
            }
            
            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 25))
                    .frame(width: 35)
                Text(metrics.energyBurned.formatted(.number.precision(.fractionLength(0))) + " \(HKStatistics.energyUnit.unitString)")
                    .font(.system(size: 30, design: .rounded))
                    .fontWeight(.semibold)
            }
            
            HStack(spacing: 6) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 25))
                    .frame(width: 35)
                Text(metrics.heartRate.formatted(.number.precision(.fractionLength(0))) + " уд/мин")
                    .font(.system(size: 30, design: .rounded))
                    .fontWeight(.semibold)
            }
            
            if metrics.workoutConfiguration.activityType == .swimming {
                HStack(spacing: 6) {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    Text(metrics.stepStrokeCount.formatted(.number.precision(.fractionLength(0))) + " гребков")
                        .font(.system(size: 30, design: .rounded))
                        .fontWeight(.semibold)
                }
            }
            
            if metrics.workoutConfiguration.activityType == .walking ||
                metrics.workoutConfiguration.activityType == .running ||
                metrics.workoutConfiguration.activityType == .highIntensityIntervalTraining, metrics.stepStrokeCount != 0 {
                HStack(spacing: 6) {
                    Image(systemName: "shoeprints.fill")
                        .foregroundColor(.purple)
                    Text(metrics.stepStrokeCount.formatted(.number.precision(.fractionLength(0))) + " шагов")
                        .font(.system(size: 30, design: .rounded))
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    let manager = WorkoutManager()
    let configuration = HKWorkoutConfiguration()
    configuration.activityType = .swimBikeRun
    
    return NavigationStack {
        WorkoutProgressView()
            .environment(manager)
            .onAppear {
                manager.workoutMetrics = .init(workoutConfiguration: configuration)
            }
    }
}
