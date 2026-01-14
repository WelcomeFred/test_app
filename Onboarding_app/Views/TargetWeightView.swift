//
//  TargetWeightView.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import SwiftUI

struct TargetWeightView: View {
    @StateObject private var viewModel = TargetWeightViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            targetWeightContent
                .navigationDestination(isPresented: $viewModel.shouldNavigateToNext) {
                    FinishView()
                }
        }
    }
    
    private var targetWeightContent: some View {
        ZStack {
            // Main background
            Color.white
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
                    
                    Color.clear
                        .frame(width: 42, height: 42)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 32)
                
                // Title and subtitle
                VStack(spacing: 8) {
                    Text("Whats your target weight?")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("This will be used to celibrate your ciustom plan")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
                
                // Current and Target weight boxes
                HStack(spacing: 16) {
                    // Current weight box
                    VStack(spacing: 8) {
                        Text("Current wt")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.black.opacity(0.6))
                        
                        WeightBox(
                            value: Int(viewModel.currentWeight),
                            unit: viewModel.isKilograms ? "kg" : "lbs",
                            isTarget: false
                        )
                    }
                    
                    // Arrow icon
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                    
                    // Target weight box
                    VStack(spacing: 8) {
                        Text("Taget")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.black.opacity(0.6))
                        
                        WeightBox(
                            value: Int(viewModel.targetWeight),
                            unit: viewModel.isKilograms ? "kg" : "lbs",
                            isTarget: true
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                
                // Weight slider/ruler
                TargetWeightSlider(
                    value: $viewModel.targetWeight,
                    minValue: viewModel.minWeight,
                    maxValue: viewModel.maxWeight,
                    unit: viewModel.isKilograms ? "kg" : "lbs"
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                
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

struct WeightBox: View {
    let value: Int
    let unit: String
    let isTarget: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isTarget ? Color.orange.opacity(0.1) : Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isTarget ? Color.orange : Color.clear, lineWidth: 1)
                )
            
            VStack(spacing: 4) {
                Text("\(value)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                
                Text(unit)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                    .padding(.bottom, isTarget ? 0 : 8)
            }
        }
        .frame(width: 120, height: 100)
    }
}

struct TargetWeightSlider: View {
    @Binding var value: Double
    let minValue: Double
    let maxValue: Double
    let unit: String
    
    @State private var dragOffset: CGFloat = 0
    private let stepWidth: CGFloat = 18
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack {
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
                                
                                if weight % 5 == 0 {
                                    Text("\(weight)")
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.top, 4)
                                }
                            }
                            .frame(width: stepWidth)
                        }
                    }
                    .offset(x: dragOffset + geometry.size.width / 2 - CGFloat(value - minValue) * stepWidth)
                    
                    // Current value indicator (orange with handle)
                    VStack(spacing: 0) {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 12, height: 12)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 6, height: 6)
                            )
                        
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 3, height: 30)
                    }
                    .position(x: geometry.size.width / 2, y: 25)
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let translation = gesture.translation.width
                            dragOffset = translation
                            
                            let steps = translation / stepWidth
                            let newValue = value - Double(steps)
                            
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
    TargetWeightView()
}

