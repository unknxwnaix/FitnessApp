//
//  ProfileViewModel.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/15/25.
//

import SwiftUI

import SwiftUI

class ProfileViewModel: ObservableObject {
    @AppStorage("username") var storedUsername: String?
    @AppStorage("emoji") private var storedEmoji: String?
    @AppStorage("color") private var storedColor: String?

    @Published var name: String = ""
    @Published var selectedEmoji: String = "😃"
    @Published var selectedBackgroundColor: Color = .gray.opacity(0.4)

    @Published var isNameEditTapped: Bool = false
    @Published var isAvatarEditTapped: Bool = false
    @Published var isContactUsTapped: Bool = false
    @Published var isPrivacyPolicyTapped: Bool = false
    @Published var showIntro: Bool = false

    let colorOptions: [Color] = [
        .red, .orange, .yellow, Color.fitnessGreenMain, .mint, .teal, .cyan, .blue, .indigo, .purple,
        .pink, .brown, .gray, .black, .white, .red.opacity(0.5), .blue.opacity(0.5), Color.fitnessGreenMain.opacity(0.5), .orange.opacity(0.5), .purple.opacity(0.5)
    ]
    
    let emojiOptions: [String] = [
        "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😊", "😇",
        "🙂", "🙃", "😉", "😍", "😘", "😜", "😎", "🥳", "🤩", "🤔", "🤓", "🥺", "🥶", "🧃"
    ]

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "Доброе утро,"
        case 12..<18: return "Добрый день,"
        case 18..<22: return "Добрый вечер,"
        default: return "Доброй ночи,"
        }
    }

    init() {
        loadStoredData()
    }

    deinit {
        saveToStorage()
    }

    private func loadStoredData() {
        name = storedUsername ?? ""
        selectedEmoji = storedEmoji ?? "😃"
        if let hexColor = storedColor {
            selectedBackgroundColor = Color.fromHex(hexColor) ?? .gray.opacity(0.4)
        }
    }

    private func saveToStorage() {
        storedUsername = name
        storedEmoji = selectedEmoji
        storedColor = selectedBackgroundColor.toHex()
    }
}

extension Color {
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    static func fromHex(_ hex: String) -> Color? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        return Color(red: r, green: g, blue: b)
    }
}
