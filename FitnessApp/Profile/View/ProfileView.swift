//
//  ProfileView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/13/25./Users/aix/Desktop/Swift & SwiftUI/iOS/DarkModeAnimation/DarkModeAnimation/Helpers
//

import SwiftUI

struct ProfileView: View {
    @Binding var showTerms: Bool
    @StateObject var vm = ProfileViewModel()
    @AppStorage("AnimationTabBounceDown") private var bounceDown: Bool = true
    
    var body: some View {
        VStack {
            ProfileHeaderView(vm: vm)
            
            Form {
                ProfileSectionView(
                    title: "Изменить",
                    settings: [
                        ProfileSetting(
                            title: "Имя",
                            image: "person.fill",
                            color: .blue,
                            isExpanded: $vm.isNameEditTapped,
                            expandedContent: {
                                AnyView(
                                    TextField("Введите имя", text: $vm.name)
                                        .textFieldStyle(ProfileTextFieldStyle())
                                        .onSubmit {
                                            withAnimation {
                                                vm.isNameEditTapped = false
                                                vm.storedUsername = vm.name
                                            }
                                        }
                                )
                            }
                        ),
                        
                        ProfileSetting(
                            title: "Аватар",
                            image: "photo.on.rectangle.fill",
                            color: .indigo,
                            isExpanded: $vm.isAvatarEditTapped,
                            expandedContent: {
                                AnyView(AvatarEditView(vm: vm))
                            }
                        )
                    ]
                )
                
                // Секция информации
                ProfileSectionView(
                    title: "ИНФО",
                    settings: [
                        ProfileSetting(
                            title: "О приложении",
                            image: "questionmark",
                            color: .yellow,
                            isExpanded: $vm.showIntro,
                            expandedContent: {
                                AnyView(EmptyView())
                            }
                        ),
                        
                        ProfileSetting(
                            title: "Связаться с нами",
                            image: "person.fill",
                            color: .orange,
                            isExpanded: $vm.isContactUsTapped,
                            expandedContent: {
                                AnyView(
                                    Link(destination: URL(string: "mailto:madmaxdmitrochenko@gmail.com")!) {
                                        Text(verbatim: "madmaxdmitrochenko@gmail.com")
                                            .foregroundStyle(.foreground)
                                    }
                                )
                            }
                        ),
                        
                        ProfileSetting(
                            title: "Политика конфиденциальности",
                            image: "photo.on.rectangle.fill",
                            color: .green,
                            isExpanded: $vm.isPrivacyPolicyTapped,
                            expandedContent: {
                                AnyView(
                                    Link("Политика конфиденциальности Firebase",
                                         destination: URL(string: "https://firebase.google.com/terms")!)
                                        .foregroundStyle(.blue)
                                )
                            }
                        )
                    ]
                )
                
                // Секция настроек приложения
                Section(header: Text("Настройки приложения")) {
                    SetupPicker()
                }
            }
            .foregroundStyle(.foreground)
        }
        .onAppear {
            vm.name = vm.storedUsername ?? ""
        }
        .padding(.top)
        .fullScreenCover(isPresented: $showTerms) {
            TermsView()
        }
        .onChange(of: vm.storedUsername) { _, newValue in
            vm.name = newValue ?? ""
        }
        .fullScreenCover(isPresented: $vm.showIntro) {
            IntroView(showIntro: $vm.showIntro)
        }
    }
    
    @ViewBuilder
    private func SetupPicker() -> some View {
        Picker("Переключение табов", selection: $bounceDown) {
            Text("Отскок вниз").tag(true)
            Text("Отскок вверх").tag(false)
        }
        .pickerStyle(.automatic)
    }
}

#Preview {
    ProfileView(showTerms: .constant(false))
}


// Модель для настройки профиля
struct ProfileSetting<Content: View> {
    let title: String
    let image: String
    let color: Color
    @Binding var isExpanded: Bool
    let expandedContent: () -> Content
}

// Стиль текстового поля
struct ProfileTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(5)
            .padding(.horizontal, 5)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

// Вью заголовка профиля
struct ProfileHeaderView: View {
    @ObservedObject var vm: ProfileViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            Text(vm.selectedEmoji)
                .font(.system(size: 80))
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .aspectRatio(1 / 1, contentMode: .fill)
                        .foregroundColor(vm.selectedBackgroundColor)
                }
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading) {
                Text(vm.greeting)
                    .font(.title)
                    .foregroundStyle(.secondary)
                Text(vm.name)
                    .font(.largeTitle)
                    .fontDesign(.rounded)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

// Вью секции профиля
struct ProfileSectionView<Content: View>: View {
    let title: String
    let settings: [ProfileSetting<Content>]
    
    var body: some View {
        Section(header: Text(title)) {
            ForEach(settings.indices, id: \.self) { index in
                let setting = settings[index]
                
                ProfileButtonView(
                    title: setting.title,
                    image: setting.image,
                    color: setting.color,
                    action: {
                        withAnimation {
                            setting.isExpanded.toggle()
                        }
                    }
                )
                
                if setting.isExpanded {
                    setting.expandedContent()
                }
            }
        }
    }
}

// Вью редактирования аватара
struct AvatarEditView: View {
    @ObservedObject var vm: ProfileViewModel
    
    var body: some View {
        VStack {
            Text("Выбрать цвет фона")
                .font(.headline)
                .padding(.top)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                ForEach(vm.colorOptions, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(vm.selectedBackgroundColor == color ? Color.fitnessGreenMain : .black, lineWidth: vm.selectedBackgroundColor == color ? 3 : 0.5)
                        )
                        .onTapGesture {
                            withAnimation {
                                vm.selectedBackgroundColor = color
                            }
                        }
                }
            }
            .padding()
            
            Text("Выбрать emoji")
                .font(.headline)
                .padding(.top)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                ForEach(vm.emojiOptions, id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 35))
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(vm.selectedEmoji == emoji ? Color.fitnessGreenMain.opacity(0.3) : Color.clear)
                        )
                        .onTapGesture {
                            withAnimation {
                                vm.selectedEmoji = emoji
                            }
                        }
                }
            }
        }
        .padding()
    }
}
