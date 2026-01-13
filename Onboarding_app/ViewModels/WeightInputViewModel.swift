//
//  WeightInputViewModel.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import Foundation
import SwiftUI

struct BMIMessage {
    let title: String
    let subtitle: String
}

class WeightInputViewModel: ObservableObject {
    @Published var weight: Double = 73.0
    @Published var isKilograms: Bool = true
    @Published var shouldNavigateToNext: Bool = false
    
    let currentPage: Int = 4
    let totalPages: Int = 8
    
    var progress: Double {
        Double(currentPage) / Double(totalPages)
    }
    
    var minWeight: Double {
        isKilograms ? 30.0 : 66.0 // 30 kg = ~66 lbs
    }
    
    var maxWeight: Double {
        isKilograms ? 200.0 : 440.0 // 200 kg = ~440 lbs
    }
    
    var bmiMessage: BMIMessage? {
        // Simple BMI calculation (assuming average height for demo)
        // BMI = weight (kg) / height (m)^2
        // For demo purposes, assuming height of 1.75m
        let heightInMeters = 1.75
        let weightInKg = isKilograms ? weight : weight * 0.453592
        let bmi = weightInKg / (heightInMeters * heightInMeters)
        
        let roundedBMI = String(format: "%.1f", bmi).replacingOccurrences(of: ".", with: ",")
        
        if bmi < 18.5 {
            return BMIMessage(
                title: "👌Your BMI is \(roundedBMI) which is considered underweight",
                subtitle: "Consider consulting with a healthcare provider"
            )
        } else if bmi < 25 {
            return BMIMessage(
                title: "👌Your BMI is \(roundedBMI) which is considered normal",
                subtitle: "You're starting from a great place"
            )
        } else if bmi < 30 {
            return BMIMessage(
                title: "👌Your BMI is \(roundedBMI) which is considered overweight",
                subtitle: "Small changes can make a big difference"
            )
        } else {
            return BMIMessage(
                title: "👌Your BMI is \(roundedBMI) which is considered obese",
                subtitle: "Let's work together to reach your goals"
            )
        }
    }
    
    func selectUnit(isKilograms: Bool) {
        if isKilograms != self.isKilograms {
            // Convert weight when switching units
            if isKilograms {
                // Convert from lbs to kg
                weight = weight * 0.453592
            } else {
                // Convert from kg to lbs
                weight = weight / 0.453592
            }
            self.isKilograms = isKilograms
            
            // Clamp weight to valid range
            weight = max(minWeight, min(maxWeight, weight))
        }
    }
    
    func handleNext() {
        shouldNavigateToNext = true
        print("Weight selected: \(weight) \(isKilograms ? "kg" : "lbs")")
    }
}

