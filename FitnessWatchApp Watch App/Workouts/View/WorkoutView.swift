//
//  Trainings.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/21/25.
//

import SwiftUI

struct WorkoutView: View {
    @Environment(WorkoutManager.self) private var workoutManager
    @StateObject private var vm = WorkoutViewModel()

    var body: some View {
        NavigationStack {
            if vm.isLoading {
                CustomProgressView()
                    .navigationTitle {
                        HeaderView()
                    }
            } else {
                ScrollView {
                    if vm.workoutsDisplay.isEmpty {
                        EmptyListMessage()
                    } else {
                        ForEach(vm.workoutsDisplay) { workout in
                            NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                WorkoutCardView(workout: workout)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .containerRelativeFrame(.vertical, count: 5, spacing: -10)
                            .scrollTargetLayout()
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.5)
                                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.8, y: phase.isIdentity ? 1 : 0.8)
                            }
                        }
                    }
                }
                .padding(.top, 7)
                .onAppear {
                    vm.reloadWorkouts()
                }
                .navigationTitle {
                    HeaderView()
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            NavigationLink(destination: {
                NewWorkoutView()
                    .environment(workoutManager)
            }, label: {
                Image(systemName: "plus")
                    .bold()
            })
            .background {
                Capsule()
                    .fill(Color.fitnessGreenMain.opacity(0.3))
                    .frame(width: 45, height: 30)
                    .padding(-6)
            }
            .padding(.trailing, 5)
            .padding(.top, 5)
            .foregroundStyle(Color.fitnessGreenMain)
            
            Spacer(minLength: 17)
            
            Text("Тренировки")
                .font(.system(size: 24))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func CustomProgressView() -> some View {
        ProgressView()
            .scaleEffect(1.5)
            .tint(Color.fitnessGreenMain)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.primary.opacity(0.2))
                    .frame(width: 40, height: 40)
            }
    }
    
    @ViewBuilder
    func EmptyListMessage() -> some View {
        Text("Нет тренировок")
            .font(.headline.bold())
            .foregroundStyle(.primary)
            .multilineTextAlignment(.center)
            .padding(.top, 10)
        
        Text("В этом месяце Вы еще не занимались. Начните тренировку прямо сейчас!")
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .lineLimit(nil)
    }
}

#Preview {
    WorkoutView()
        .environment(WorkoutManager())
}
