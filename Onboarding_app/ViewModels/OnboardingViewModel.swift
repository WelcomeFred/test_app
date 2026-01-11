//
//  OnboardingViewModel.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
//    @Published var currentPage: Int = 1
    @Published var isOnboardingComplete: Bool = false
    @Published var shouldShowGenderSelection: Bool = false
    
    func handleGetStarted() {
        // Navigate to gender selection screen
        shouldShowGenderSelection = true
        print("Get Started tapped")
    }
}


