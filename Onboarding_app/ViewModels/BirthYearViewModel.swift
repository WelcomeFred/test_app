//
//  BirthYearViewModel.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import Foundation
import SwiftUI

class BirthYearViewModel: ObservableObject {
    @Published var selectedYear: Int = 1990
    @Published var shouldNavigateToNext: Bool = false
    
    let currentPage: Int = 6
    let totalPages: Int = 8
    
    var progress: Double {
        Double(currentPage) / Double(totalPages)
    }
    
    var minYear: Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        return currentYear - 100 // 100 years ago
    }
    
    var maxYear: Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        return currentYear - 13 // At least 13 years old
    }
    
    func handleNext() {
        // Save data
        UserDefaults.standard.set(selectedYear, forKey: "userBirthYear")
        
        // Navigation
        shouldNavigateToNext = true
        print("Birth year selected: \(selectedYear)")
    }
}

