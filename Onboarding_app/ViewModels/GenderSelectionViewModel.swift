//
//  GenderSelectionViewModel.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import Foundation
import SwiftUI

enum Gender: String {
    case male
    case female
//    case preferNotToSay
}

class GenderSelectionViewModel: ObservableObject {
    @Published var selectedGender: Gender?
    @Published var shouldNavigateToNext: Bool = false
    
    let currentPage: Int = 2
    let totalPages: Int = 8
    
    var progress: Double {
        Double(currentPage) / Double(totalPages)
    }
    
    func selectGender(_ gender: Gender) {
        selectedGender = gender
    }
    
    func handleNext() {
        guard selectedGender != nil else { return }
        // Handle navigation to next screen
        shouldNavigateToNext = true
        print("Gender selected: \(selectedGender?.rawValue ?? "none")")
    }
}

