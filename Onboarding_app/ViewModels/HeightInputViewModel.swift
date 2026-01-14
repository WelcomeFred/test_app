//
//  HeightInputViewModel.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import Foundation
import SwiftUI

class HeightInputViewModel: ObservableObject {
    @Published var height: Double = 175 // cm by default
    @Published var isCentimeters: Bool = true
    @Published var shouldNavigateToNext: Bool = false
    
    var minHeight: Double {
        isCentimeters ? 100 : 39.37
    }
    
    var maxHeight: Double {
        isCentimeters ? 250 : 98.43 
    }
    
    var progress: Double = 0.7
    
    var heightDisplay: String {
        if isCentimeters {
            return "\(Int(height)) cm"
        } else {
            let feet = Int(height / 12)
            let inches = Int(height.truncatingRemainder(dividingBy: 12))
            return "\(feet)' \(inches)\""
        }
    }
    
    func selectUnit(isCentimeters: Bool) {
        withAnimation {
            self.isCentimeters = isCentimeters
            
            if isCentimeters {
                // inches to cm
                height = round(height * 2.54)
            } else {
                // cm to inches
                height = round(height / 2.54)
            }
        }
    }
    
    func handleNext() {
        // Պահպանել տվյալները
        UserDefaults.standard.set(height, forKey: "userHeight")
        UserDefaults.standard.set(isCentimeters, forKey: "heightUnitIsCm")
        
        // Նավիգացիա
        shouldNavigateToNext = true
    }
}
