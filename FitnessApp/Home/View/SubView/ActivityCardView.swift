//
//  ActivityCardView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import SwiftUI

struct ActivityCardView: View {
    @State var activity: Activity
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack (spacing: 8) {
                Label(activity.title, systemImage: activity.image)
                    .foregroundStyle(activity.tintColor)
                    .bold()
                
                Text(activity.subtitle)
                    .font(.caption)
                
                Text(activity.amount)
                    .font(.system(.title, design: .rounded))
                    .bold()
                    .padding(.top, 10)
            }
            .padding()
        }
    }
}

#Preview {
    ActivityCardView(
        activity: Activity(
            title: "Today steps",
            subtitle: "Goal 12,000",
            image: "figure.walk",
            tintColor: .green,
            amount: "6,123"
        )
    )
}
