//
//  ActivityCardView.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/21/25.
//

import SwiftUI

struct ActivityCardView: View {
    private let frameHeight: CGFloat = 55
    let activity: Activity
    let isTapped: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            Color(activity.tintColor.opacity(isTapped ? 0.4 : 0.3))
                .cornerRadius(8)
            
            HStack(alignment: .center, spacing: isTapped ? 6 : 5) {
                Capsule()
                    .foregroundStyle(activity.tintColor)
                    .frame(width: isTapped ? 6 : .zero, height: isTapped ? .infinity : .zero)
                
                VStack(alignment: .leading, spacing: isTapped ? 5 : 0) {
                    CardImage()
                    TitleText()
                    SubtitleText()
                }
                
                Spacer()
            }
            .padding(5)
            .overlay(alignment: isTapped ? .topTrailing : .trailing) {
                AmountText()
            }
        }
        .frame(minHeight: 55, maxHeight: isTapped ? 130 : 55)
        .onTapGesture {
            onTap()
        }
    }
    
    @ViewBuilder
    func CardImage() -> some View {
        if isTapped {
            Image(systemName: activity.image)
                .frame(height: 50)
                .foregroundStyle(activity.tintColor)
                .font(.system(size: 45))
                .padding(.top, 5)
                .transition(.opacity.combined(with: .scale))
        }
    }
    
    @ViewBuilder
    func TitleText() -> some View {
        Text(activity.title)
            .font(isTapped ? .title2 : .title3)
            .fontDesign(.rounded)
            .foregroundColor(.white.opacity(0.9))
            .frame(maxWidth: isTapped ? 200 : 100, alignment: .leading)
            .lineLimit(isTapped ? nil : 1)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    func SubtitleText() -> some View {
        if isTapped {
            Text(activity.subtitle)
                .frame(height: frameHeight / 3)
                .font(.title3)
                .fontDesign(.rounded)
                .foregroundColor(.white.opacity(0.7))
                .transition(.opacity)
                .padding(.bottom)
        }
    }
    
    @ViewBuilder
    func AmountText() -> some View {
        Text(activity.amount)
            .font(.system(size: isTapped ? 20 : 20, weight: .semibold, design: .rounded))
            .fontDesign(.rounded)
            .foregroundColor(.white.opacity(0.9))
            .padding(3)
            .padding(.horizontal, 5)
            .background {
                Capsule()
                    .fill(activity.tintColor)
                    .opacity(isTapped ? 1 : 0)
                    .shadow(radius: 3)
            }
            .padding(10)
    }
}

#Preview {
    ActivitiesView()
}


