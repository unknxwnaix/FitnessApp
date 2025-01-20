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

struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let image: String
    let tintColor: Color
    let amount: String
}

extension Activity {
    static var mockActivities: [Activity] = [
        Activity(
            title: "Today steps",
            subtitle: "Goal 12,000",
            image: "figure.run",
            tintColor: .green,
            amount: "6,123"
        ),
        
        Activity(
            title: "Today",
            subtitle: "Goal 1,000",
            image: "figure.walk",
            tintColor: .red,
            amount: "812"
        ),
        
        Activity(
            title: "Today steps",
            subtitle: "Goal 12,000",
            image: "figure.walk",
            tintColor: .blue,
            amount: "6,123"
        ),
        
        Activity(
            title: "Today steps",
            subtitle: "Goal 50,000",
            image: "figure.run",
            tintColor: .purple,
            amount: "55,812"
        )

    ]
}
