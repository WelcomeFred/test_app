//
//  WeightInputView.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import SwiftUI

struct WeightInputView: View {
    @StateObject private var viewModel = WeightInputViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Main background
            Color(red: 0.96, green: 0.95, blue: 0.93)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation bar with back button and progress bar
                HStack(spacing: 12) {
                    // Back button
                    Button(action: {
                        dismiss()
                    }) {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .padding(12)
                            .clipShape(Circle())
                    }
                    .frame(width: 42, height: 42)
                    
                    Spacer()
                    
                    // Progress bar (centered)
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 4)
                            
                            Capsule()
                                .fill(Color(
                                    red: 147/255,
                                    green: 27/255,
                                    blue: 255/255
                                ))
                                .frame(
                                    width: geometry.size.width * viewModel.progress,
                                    height: 4
                                )
                        }
                    }
                    .frame(height: 4)
                    .frame(maxWidth: 200)
                    
                    Spacer()
                    
                    // Invisible spacer to balance the back button
                    Color.clear
                        .frame(width: 42, height: 42)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 32)
                
                // Question
                Text("What's your current weight?")
                    .font(.system(size: 22, weight: .bold, design: .serif))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                
                // Weight scale illustration
                Image("body-measurements-tracker")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 32)
                
                // Unit selection (at the top)
                HStack(spacing: 0) {
                    UnitButton(
                        title: "lbs",
                        isSelected: !viewModel.isKilograms,
                        onSelect: {
                            viewModel.selectUnit(isKilograms: false)
                        }
                    )
                    
                    UnitButton(
                        title: "kg",
                        isSelected: viewModel.isKilograms,
                        onSelect: {
                            viewModel.selectUnit(isKilograms: true)
                        }
                    )
                }
                .padding(.horizontal, 80)
                .padding(.bottom, 32)
                
                // Weight value display
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(Int(viewModel.weight))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(viewModel.isKilograms ? "kg" : "lbs")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 24)
                
                // Weight slider/ruler
                WeightSlider(
                    value: $viewModel.weight,
                    minValue: viewModel.minWeight,
                    maxValue: viewModel.maxWeight,
                    unit: viewModel.isKilograms ? "kg" : "lbs"
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                // BMI feedback
                if let bmiMessage = viewModel.bmiMessage {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(bmiMessage.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(bmiMessage.subtitle)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color.green)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
                
                Spacer()
                
                // Next button
                Button(action: {
                    viewModel.handleNext()
                }) {
                    Text("Next")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct UnitButton: View {
    let title: String
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isSelected ? .white : .black)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? Color.orange : Color.gray.opacity(0.1))
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

struct WeightSlider: View {
    @Binding var value: Double
    let minValue: Double
    let maxValue: Double
    let unit: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Ruler with ticks and scrollable
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Ruler ticks
                    ForEach(0..<Int(maxValue - minValue) + 1, id: \.self) { index in
                        let tickValue = minValue + Double(index)
                        let isMajorTick = Int(tickValue).isMultiple(of: 5)
                        let isMinorTick = !isMajorTick
                        let shouldShowLabel = isMajorTick || (Int(tickValue) >= 120 && Int(tickValue) <= 135)
                        let position = CGFloat((tickValue - minValue) / (maxValue - minValue)) * geometry.size.width
                        
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 1, height: isMajorTick ? 20 : (isMinorTick ? 10 : 5))
                            
                            if shouldShowLabel {
                                Text("\(Int(tickValue))")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                    .padding(.top, 4)
                            }
                        }
                        .offset(x: position - 0.5)
                    }
                    
                    // Current value indicator (thick blue bar) - centered
                    let centerPosition = CGFloat((value - minValue) / (maxValue - minValue)) * geometry.size.width
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 4, height: 30)
                        .offset(x: centerPosition - 2)
                }
            }
            .frame(height: 50)
            
            // Slider control (scrollable and interactive)
            Slider(
                value: $value,
                in: minValue...maxValue,
                step: 1
            )
            .tint(Color.blue)
        }
    }
}

#Preview {
    WeightInputView()
}

