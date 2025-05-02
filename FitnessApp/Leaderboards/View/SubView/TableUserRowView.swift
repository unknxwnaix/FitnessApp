//
//  TableUserRowView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 5/2/25.
//

import SwiftUI

struct TableUserRowView<T: ShapeStyle>: View {
    let position: Int
    let person: LeaderboardUser
    let tint: T
    @AppStorage("username") var username: String?
    let shadowRadius: CGFloat = 3.0
    
    var body: some View {
        HStack {
            Text("\(position).")
                .font(.headline.bold())
                .fontDesign(.rounded)
                .foregroundStyle(.primary)
                .shadow(radius: shadowRadius)
            
            Text(person.username)
                .shadow(radius: shadowRadius)
            
            if username == person.username {
                Image(systemName: "crown.fill")
                    .foregroundStyle(Color.fitnessGreenMain)
                    .bold()
            }
            
            Spacer()
            
            Text("\(person.count)")
                .shadow(radius: shadowRadius)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 8)
            .fill(tint)
        )
        .padding(.horizontal, 5)
    }
}


#Preview {
    TableUserRowView(position: 1, person: LeaderboardUser(username: "Dima", count: 12334), tint: .yellow)
}
