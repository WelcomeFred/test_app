//
//  ExerciseFrequencyViewModel.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import Foundation
import SwiftUI

class ExerciseFrequencyViewModel: ObservableObject {
    @Published var selectedOption: ExerciseOption?
    @Published var selectedDays: [Int: [Int]] = [:] // [optionId: [dayIndices]]
    @Published var shouldNavigateToNext: Bool = false
    
    let currentPage: Int = 3
    let totalPages: Int = 8
    
    var progress: Double {
        Double(currentPage) / Double(totalPages)
    }
    
    let options: [ExerciseOption] = [
        ExerciseOption(
            id: 1,
            title: "Workout now and then",
            frequency: "0-2",
            defaultDays: [0, 3]
        ),
        ExerciseOption(
            id: 2,
            title: "A few workouts per week",
            frequency: "3-5",
            defaultDays: [0, 3, 1]
        ),
        ExerciseOption(
            id: 3,
            title: "Dedicared athlete",
            frequency: "6+",
            defaultDays: [0, 3, 1, 2, 4, 5]
        )
    ]
    
    init() {
        // Initialize with default days for each option
        for option in options {
            selectedDays[option.id] = option.defaultDays
        }
    }
    
    func selectOption(_ option: ExerciseOption) {
        selectedOption = option
    }
    
    func toggleDay(for optionId: Int, day: Int) {
        guard let option = options.first(where: { $0.id == optionId }) else { return }
        
        if var days = selectedDays[optionId] {
            if let index = days.firstIndex(of: day) {
                days.remove(at: index)
            } else {
                days.append(day)
            }
            selectedDays[optionId] = days
        } else {
            selectedDays[optionId] = [day]
        }
    }
    
    func handleNext() {
        guard selectedOption != nil else { return }
        // Handle navigation to next screen
        shouldNavigateToNext = true
        print("Exercise frequency selected: \(selectedOption?.title ?? "none")")
    }
}

