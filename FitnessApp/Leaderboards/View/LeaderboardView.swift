//
//  LeaderboardView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/10/25.
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var vm = LeaderboardViewModel()
    @AppStorage("username") var username: String?
    @Binding var showTerms: Bool
    
    var body: some View {
        NavigationStack {
            if vm.isLoading {
                CustomProgressView()
            } else {
                VStack {
                    TableHeader()
                    
                    LazyVStack(spacing: 8) {
                        ForEach(Array(vm.leaderResult.top10.enumerated()), id: \.element.id) { (index, person) in
                            TableUserRow(index: index, person: person)
                        }
//                        ForEach(Array(vm.mockData.enumerated()), id: \.element.id) { (index, person) in
//                            TableUserRow(index: index, person: person)
//                        }
                    }
                    
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundStyle(.gray.opacity(0.5))
                    
                    if let user = vm.leaderResult.user {
                        HStack {
                            Text("--")
                                .font(.headline.bold())
                                .fontDesign(.rounded)
                                .foregroundStyle(.primary)
                            
                            Text(user.username)
                            
                            Spacer()
                            
                            Text("\(user.count)")
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(.gray.opacity(0.2))
                        )
                        .padding(.horizontal, 5)
                    }
                    
                    Spacer()
                }
                .navigationTitle("Таблица лидеров")
                .fullScreenCover(isPresented: $showTerms) {
                    TermsView()
                }
                .onChange(of: showTerms) {
                    Task {
                        do {
                            if !showTerms && username != nil {
                                try await vm.setupLeaderboardData()
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .onChange(of: username) { oldValue, newValue in
                    if username != nil {
                        Task {
                            do {
                                try await vm.updateUsername(oldUsername: oldValue ?? "", newUsername: newValue ?? "")
                                try await vm.setupLeaderboardData()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                .onChange(of: vm.data) { _, newValue in
                    withAnimation {
                        vm.leaderResult = newValue
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func TableHeader() -> some View {
        HStack {
            Text("Имя")
                .font(.title2.bold())
            
            Spacer()
            
            Text("Шаги")
                .font(.title2.bold())
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    @ViewBuilder
    func TableUserRow(index: Int, person: LeaderboardUser) -> some View {
        //MARK: Index 0 = 1st place, 1 = 2nd place, 2 = 3rd place...
        switch index + 1 {
        case 1:
            TableUserRowView(position: index + 1, person: person, tint: .yellow)
        case 2:
            TableUserRowView(position: index + 1, person: person, tint: .gray.opacity(0.8))
        case 3:
            TableUserRowView(position: index + 1, person: person, tint: .brown)
        case _:
            TableUserRowView(position: index + 1, person: person, tint: .gray.opacity(0.2))
        }
    }
    
    @ViewBuilder
    func CustomProgressView() -> some View {
        ProgressView()
            .scaleEffect(2)
            .tint(Color.fitnessGreenMain)
            .padding(18)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.primary.opacity(0.2))
            }
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(false))
}
