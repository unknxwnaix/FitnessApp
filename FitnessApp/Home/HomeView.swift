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
    
    var mockData: [Activity] = [
        .init(
            title: "Today steps",
            subtitle: "Goal 12,000",
            image: "figure.run",
            tintColor: .green,
            amount: "6,123"
        ),
        .init(
            title: "Today",
            subtitle: "Goal 1,000",
            image: "figure.walk",
            tintColor: .red,
            amount: "812"
        ),
        .init(
            title: "Today steps",
            subtitle: "Goal 12,000",
            image: "figure.walk",
            tintColor: .blue,
            amount: "6,123"
        ),
        .init(
            title: "Today steps",
            subtitle: "Goal 50,000",
            image: "figure.run",
            tintColor: .purple,
            amount: "55,812"
        )

    ]
    
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
                            ForEach(mockData, id: \.id) { activity in
                                ActivityCardView(activity: activity)
                            }
                        } header: {
                            HStack {
                                Text("Fitness Activity")
                                    .font(.title2)
                                
                                Spacer()
                                
                                Button {
                                    print("show more")
                                } label: {
                                    Text("Show More")
                                }
                                .buttonStyle(.bordered)
                                .tint(.green)
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Welcome")
        }
    }
}

#Preview {
    HomeView()
}
