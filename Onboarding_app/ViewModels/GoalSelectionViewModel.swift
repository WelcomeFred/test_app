//
//  GoalSelectionViewModel.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import Foundation
import SwiftUI

class GoalSelectionViewModel: ObservableObject {
    @Published var selectedGoal: Goal?
    @Published var shouldNavigateToNext: Bool = false
    
    let currentPage: Int = 7
    let totalPages: Int = 8
    
    var progress: Double {
        Double(currentPage) / Double(totalPages)
    }
    
    let goals: [Goal] = [
        Goal(
            id: 1,
            title: "Lose Weight",
            iconName: "loseWeight",
            color: .red
        ),
        Goal(
            id: 2,
            title: "Maintain",
            iconName: "maintain",
            color: Color(
                red: 147/255,
                green: 27/255,
                blue: 255/255
            )
        ),
        Goal(
            id: 3,
            title: "Gain Weight",
            iconName: "gainWeight",
            color: .orange
        )
    ]
    
    func selectGoal(_ goal: Goal) {
        selectedGoal = goal
    }
    
    func handleNext() {
        guard selectedGoal != nil else { return }
        
        // Save data
        UserDefaults.standard.set(selectedGoal?.id, forKey: "userGoal")
        
        // Navigation
        shouldNavigateToNext = true
        print("Goal selected: \(selectedGoal?.title ?? "none")")
    }
}

