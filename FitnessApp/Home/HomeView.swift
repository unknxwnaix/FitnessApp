//
//  HomeView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import SwiftUI

struct HomeView: View {
    @State var calories: Int = 320
    @State var active: Int = 52
    @State var stand: Int = 8
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack (alignment: .leading) {
                    HStack {
                        ZStack {
                            ProgressCircleView(progress: $calories, goal: 460, color: .pink)
                            
                            ProgressCircleView(progress: $active, goal: 60, color: .green)
                                .padding(20)
                            
                            ProgressCircleView(progress: $stand, goal: 12, color: .mint)
                                .padding(40)
                        }
                        .frame(width: 220, height: 220)
                        .shadow(radius: 5, x: 3, y: 3)
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        VStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Calories")
                                    .font(.callout)
                                    .bold()
                                    .foregroundStyle(.pink)
                                
                                Text("\(calories) kcal")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Active")
                                    .font(.callout)
                                    .bold()
                                    .foregroundStyle(.green)
                                
                                Text("\(active) mins")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Stand")
                                    .font(.callout)
                                    .bold()
                                    .foregroundStyle(.mint)
                                
                                Text("\(stand) hours")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                        }
                        
                        Spacer()
                    }
                    .padding(.trailing)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing:10), count: 2)) {
                        
                        Section {
                            ForEach(Activity.mockActivities, id: \.id) { activity in
                                ActivityCardView(activity: activity)
                            }
                        } header: {
                            HStack {
                                Text("Fitness Activity")
                                    .font(.title2)
                                
                                Spacer()
                                
                                NavigationLink {
                                    EmptyView()
                                } label: {
                                    Text("Show More")
                                }
                                .buttonStyle(.bordered)
                                .tint(.green)
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    LazyVStack {
                        Section {
                            ForEach(Workout.mockWorkouts, id: \.id) { workout in
                                WorkoutCardView(workout: workout)
                            }
                        } header: {
                            HStack {
                                Text("Recent Workouts")
                                    .font(.title2)
                                
                                Spacer()
                                
                                NavigationLink {
                                    EmptyView()
                                } label: {
                                    Text("Show More")
                                }
                                .buttonStyle(.bordered)
                                .tint(.green)
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .navigationTitle("Welcome")
        }
    }
}

#Preview {
    HomeView()
}
