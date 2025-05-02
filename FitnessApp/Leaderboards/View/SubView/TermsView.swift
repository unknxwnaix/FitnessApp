//
//  TermsOfLeaderBoard.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/10/25.
//

import SwiftUI

struct TermsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("username") var username: String?
    @State var name: String = ""
    
    @State var acceptedTerms: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Имя пользователя", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
                
                HStack(alignment: .top) {
                    Button {
                        withAnimation {
                            acceptedTerms.toggle()
                        }
                    } label: {
                        if acceptedTerms {
                            Image(systemName: "square.inset.filled")
                        } else {
                            Image(systemName: "square")
                        }
                    }
                    .foregroundStyle(Color.fitnessGreenMain)
                    
                    Text("Нажмите здесь, чтобы подтвердить согласие с пользовательским соглашением")
                }
                .padding(.horizontal)
                
                Button {
                    if acceptedTerms && name.count > 2 {
                        username = name
                        dismiss()
                    }
                } label: {
                    Text("Продолжить")
                        .frame(maxWidth: .infinity)
                        .padding(8)
                }
                .padding(.horizontal)
                .buttonStyle(.borderedProminent)
                .tint(Color.fitnessGreenMain)
                
                Spacer()
            }
            .navigationBarTitle("Таблица лидеров")
        }
    }
}

#Preview {
    TermsView()
}
