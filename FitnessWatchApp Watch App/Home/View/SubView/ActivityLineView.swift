//
//  ActivityCardView.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/21/25.
//

import SwiftUI

struct ActivityLineView: View {
    var title: String
    @Binding var value: Int
    var color: Color
    var goal: Int
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(value) / \(goal)")
                .foregroundStyle(color)
        }
        .bold()
        .fontDesign(.rounded)
    }
}

#Preview {
    ActivityLineView(title: "Activity", value: .constant(300), color: .red, goal: 400)
}
