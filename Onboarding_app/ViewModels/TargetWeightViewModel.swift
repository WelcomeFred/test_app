//
//  TargetWeightViewModel.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import Foundation
import SwiftUI

class TargetWeightViewModel: ObservableObject {
    @Published var targetWeight: Double = 100.0
    @Published var shouldNavigateToNext: Bool = false
    
    let currentPage: Int = 8
    let totalPages: Int = 8
    
    var progress: Double {
        Double(currentPage) / Double(totalPages)
    }
    
    var currentWeight: Double {
        // Read from UserDefaults (saved in WeightInputView)
        let savedWeight = UserDefaults.standard.double(forKey: "userWeight")
        return savedWeight > 0 ? savedWeight : 73.0 // Default to 73 if not set
    }
    
    var isKilograms: Bool {
        // Read from UserDefaults
        return UserDefaults.standard.bool(forKey: "weightUnitIsKg")
    }
    
    var minWeight: Double {
        isKilograms ? 30.0 : 66.0
    }
    
    var maxWeight: Double {
        isKilograms ? 199 : 440.0
    }
    
    init() {
        // Initialize target weight based on current weight
        targetWeight = max(currentWeight - 10, minWeight) // Default to 10 kg less than current
    }
    
    func handleNext() {
        // Save data
        UserDefaults.standard.set(targetWeight, forKey: "userTargetWeight")
        
        // Navigation
        shouldNavigateToNext = true
        print("Target weight selected: \(targetWeight) \(isKilograms ? "kg" : "lbs")")
    }
}

