//
//  Double+Ext.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/11/25.
//

import Foundation

extension Double {
    func formattedNumberString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
