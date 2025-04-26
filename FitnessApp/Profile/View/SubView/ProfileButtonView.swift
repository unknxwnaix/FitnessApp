//
//  ProfileButtonView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/15/25.
//

import SwiftUI

struct ProfileButtonView: View {
    var title: String
    var image: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: image)
                    .foregroundStyle(.white)
                    .scaledToFill()
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(color.gradient)
                            .frame(width: 30, height: 30)
                    }
                    .frame(width: 30, height: 30)
                Text(title)
            }
        }
    }
}

#Preview {
    ProfileButtonView(title: "О нас", image: "house", color: .green, action: {})
}
