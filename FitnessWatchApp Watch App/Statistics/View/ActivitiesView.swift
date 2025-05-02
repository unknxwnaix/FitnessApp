//
//  WeeklyActivitiesView.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/21/25.
//

import SwiftUI

struct ActivitiesView: View {
    @StateObject private var vm = ActivitiesViewModel()
    @State private var expandedCardId: UUID? = nil
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(vm.activities) { activity in
                        ActivityCardView(
                            activity: activity,
                            isTapped: expandedCardId == activity.id,
                            onTap: {
                                withAnimation(.bouncy(duration: 0.4, extraBounce: 0.1)) {
                                    if expandedCardId == activity.id {
                                        expandedCardId = nil
                                    } else {
                                        expandedCardId = activity.id
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                            withAnimation(.easeInOut(duration: 0.35)) {
                                                proxy.scrollTo(activity.id, anchor: .center)
                                            }
                                        }
                                    }
                                }
                            }
                        )
                        .id(activity.id)
                        .containerRelativeFrame(.vertical, count: expandedCardId == activity.id ? 1 : 3, spacing: -10)
                        .scrollTargetLayout()
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.5)
                                .scaleEffect(x: phase.isIdentity ? 1.0 : 0.8, y: phase.isIdentity ? 1 : 0.8)
                        }
                    }
                }
            }
            .navigationTitle("Cводка")
        }
    }
}

#Preview {
    ActivitiesView()
}
