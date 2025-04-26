//
//  RectKey.swift
//  DarkModeAnimation
//
//  Created by Maxim Dmitrochenko on 3/21/25.
//

import SwiftUI

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
