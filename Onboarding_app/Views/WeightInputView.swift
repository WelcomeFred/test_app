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
                            .font(.system(size: 14, weight: .bold))
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
                .background(isSelected ? Color(
                                red: 234/255,
                                green: 121/255,
                                blue: 97/255
                            ): Color.gray.opacity(0.1))
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
    
    @State private var dragOffset: CGFloat = 0
    @GestureState private var isDragging = false
    
    private let stepWidth: CGFloat = 7
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack {
                    // Ruler background
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 50)
                        .contentShape(Rectangle())
                    
                    // Ruler ticks
                    HStack(spacing: 0) {
                        ForEach(Int(minValue)...Int(maxValue), id: \.self) { weight in
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 2, height: weight % 5 == 0 ? 25 : 10)
                            }
                            .frame(width: stepWidth)
                        }
                    }
                    .offset(x: dragOffset + geometry.size.width / 2 - CGFloat(value - minValue) * stepWidth)
                    
                    // Current value indicator (centered)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 4, height: 30)
                        .position(x: geometry.size.width / 2, y: 25)
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let translation = gesture.translation.width
                            dragOffset = translation
                            
                            // Հաշվարկել նոր արժեքը
                            let steps = translation / stepWidth
                            let newValue = value - Double(steps)
                            
                            // Սահմանափակել արժեքը
                            let clampedValue = min(maxValue, max(minValue, newValue))
                            
                            if abs(clampedValue - value) > 0.01 {
                                withAnimation(.interactiveSpring()) {
                                    value = clampedValue
                                }
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                dragOffset = 0
                                value = round(value)
                            }
                        }
                )
            }
            .frame(height: 50)
            .clipped()
        }
    }
}

#Preview {
    WeightInputView()
}

