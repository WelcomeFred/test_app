//
//  NutritionalWidget.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import SwiftUI

struct NutritionalWidget: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                // White circle background
                Circle()
                    .fill(Color.white)
                    .frame(width: 70, height: 70)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                
                // Progress arc at the top
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .frame(width: 70, height: 70)
                    .rotationEffect(.degrees(-90))
                
                // Icon in the center
                Image(systemName: iconName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
            
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
        }
    }
    
    private var iconName: String {
        switch icon {
        case "wheat":
            return "leaf.fill"
        case "meat":
            return "flame.fill"
        case "apple":
            return "applelogo"
        default:
            return "circle.fill"
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        NutritionalWidget(
            icon: "wheat",
            label: "Carbs",
            value: "24g",
            color: .orange
        )
    }
}

