//
//  HomeView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        @State var calories: Int = 320
        @State var active: Int = 52
        @State var stand: Int = 8
        
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
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

                    ZStack {
                        ProgressCircleView(progress: $calories, goal: 460, color: .pink)
                        
                        ProgressCircleView(progress: $active, goal: 60, color: .green)
                            .padding(20)
                        
                        ProgressCircleView(progress: $stand, goal: 12, color: .mint)
                            .padding(40)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
