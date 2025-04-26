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
            VStack {
                HStack {
                    Text("Имя")
                        .bold()
                    
                    Spacer() 
                    
                    Text("Шаги")
                        .bold()
                }
                .padding()
                
                LazyVStack(spacing: 16) {
                    ForEach(Array(vm.leaderResult.top10.enumerated()), id: \.element.id) { (index, person) in
                        HStack {
                            Text("\(index + 1).")
                                
                            Text(person.username)
                            
                            if username == person.username {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(.yellow)
                            }
                            
                            Spacer()
                            
                            Text("\(person.count)")
                        }
                        .padding(.horizontal)
                    }
                }
                
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.gray.opacity(0.5))
                
                if let user = vm.leaderResult.user {
                    HStack {
                        Text("-")
                            
                        Text(user.username)
                        
                        Spacer()
                        
                        Text("\(user.count)")
                    }
                    .padding(.horizontal)
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
        }
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(false))
}
