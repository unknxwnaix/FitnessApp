//
//  FitnessTabView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import SwiftUI

struct FitnessTabView: View {
    
    @State private var selectedTab: Tab = .home
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    
    @AppStorage("username") var username: String?
    @AppStorage("AnimationTabBounceDown") private var bounceDown: Bool?
    @State var showTerms: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    VStack {
                        HomeView()
                    }
                }
                .navigationTitle(Tab.home.title)
                .setupTab(.home)
                
                NavigationStack {
                    VStack {
                        ChartsView()
                    }
                }
                .navigationTitle(Tab.charts.title)
                .setupTab(.charts)
                
                NavigationStack {
                    VStack {
                        LeaderboardView(showTerms: $showTerms)
                    }
                }
                .navigationTitle(Tab.leaderboard.title)
                .setupTab(.leaderboard)
                
                NavigationStack {
                    VStack {
                        ProfileView(showTerms: $showTerms)
                    }
                }
                .navigationTitle(Tab.profile.title)
                .setupTab(.profile)
            }
            CustomTabBar()
        }
        .onAppear {
            if username == nil {
                print("username: nil")
            } else {
                print("username: \(username!)")
            }
            showTerms = username == nil
            
            if bounceDown == nil {
                UserDefaults.standard.set(true, forKey: "AnimationTabBounceDown")
            }
        }
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                        .symbolEffect(bounceDown ?? true ? .bounce.down.byLayer : .bounce.up.byLayer, value: animatedTab.isAnimating)
                    
                    Text(tab.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                .foregroundStyle(selectedTab == tab ? .green : .secondary)
                .frame(maxWidth: .infinity)
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete) {
                        selectedTab = tab
                        animatedTab.isAnimating = true
                    } completion: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimating = nil
                        }
                    }
                }
            }
        }
        .background(.bar)
    }
}

#Preview {
    FitnessTabView()
}


extension View {
    @ViewBuilder
    func setupTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
