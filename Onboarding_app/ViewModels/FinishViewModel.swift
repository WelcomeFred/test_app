//
//  FinishViewModel.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import Foundation
import SwiftUI

class FinishViewModel: ObservableObject {
    @Published var shouldCompleteOnboarding: Bool = false
    
    let currentPage: Int = 9
    let totalPages: Int = 8
    
    var progress: Double {
        // 100% complete
        return 1.0
    }
    
    func handleFinish() {
        // Mark onboarding as complete
        UserDefaults.standard.set(true, forKey: "isOnboardingComplete")
        
        // Navigate to main app
        shouldCompleteOnboarding = true
        print("Onboarding completed!")
    }
}

