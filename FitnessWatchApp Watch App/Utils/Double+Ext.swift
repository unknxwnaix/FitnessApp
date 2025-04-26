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

extension Double {
    func formattedNumberStringWithSuffix(_ suffix: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.locale = Locale.current
        return (numberFormatter.string(from: NSNumber(value: self)) ?? "-") + " " + suffix
    }
    
    func formattedDistanceString() -> String {
        let distanceInKilometers = self / 1000
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.locale = Locale.current
        return (numberFormatter.string(from: NSNumber(value: distanceInKilometers)) ?? "-") + " км"
    }
    
    func formattedPaceString() -> String {
        let minutes = Int(self)
        let seconds = Int((self - Double(minutes)) * 60)
        return String(format: "%d:%02d мин/км", minutes, seconds)
    }
}
