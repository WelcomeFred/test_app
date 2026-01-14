//
//  HeightInputView.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import SwiftUI

struct HeightInputView: View {
    @StateObject private var viewModel = HeightInputViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            heightInputContent
                .navigationDestination(isPresented: $viewModel.shouldNavigateToNext) {
                    BirthYearView()
                }
        }
    }
    
    private var heightInputContent: some View {
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
                
                // Question
                Text("What's your height?")
                    .font(.system(size: 22, weight: .bold, design: .serif))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                
                // Unit selection
                HStack(spacing: 0) {
                    UnitButton(
                        title: "ft, in",
                        isSelected: !viewModel.isCentimeters,
                        onSelect: {
                            viewModel.selectUnit(isCentimeters: false)
                        }
                    )
                    
                    UnitButton(
                        title: "cm",
                        isSelected: viewModel.isCentimeters,
                        onSelect: {
                            viewModel.selectUnit(isCentimeters: true)
                        }
                    )
                }
                .padding(.horizontal, 80)
                .padding(.bottom, 32)
                
                HStack(spacing: 0) {
                    VStack {
                        Spacer()
                        
                        // Height input field
                        HStack(spacing: 8) {
                            // Indicator dot
                            Circle()
                                .fill(Color(
                                    red: 234/255,
                                    green: 121/255,
                                    blue: 97/255
                                ))
                                .frame(width: 8, height: 8)
                            
                            // Horizontal line
                            Rectangle()
                                .fill(Color(
                                    red: 234/255,
                                    green: 121/255,
                                    blue: 97/255
                                ))
                                .frame(width: 20, height: 2)
                            
                            // Height value input
                            Text(viewModel.heightDisplay)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 80, alignment: .leading)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    .frame(width: 120)
                    
                    ZStack {
                         Image("man-shape")
                             .resizable()
                             .scaledToFit()
                             .frame(width: 150, height: 400)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 0) {
                        HeightRuler(
                            value: $viewModel.height,
                            minValue: viewModel.minHeight,
                            maxValue: viewModel.maxHeight,
                            unit: viewModel.isCentimeters ? "cm" : "ft"
                        )
                    }
                    .frame(width: 60)
                    .padding(.trailing, 20)
                }
                .frame(maxHeight: .infinity)
                .padding(.bottom, 40)
                
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

//struct UnitButton: View {
//    let title: String
//    let isSelected: Bool
//    let onSelect: () -> Void
//    
//    var body: some View {
//        Button(action: onSelect) {
//            Text(title)
//                .font(.system(size: 16, weight: .semibold))
//                .foregroundColor(isSelected ? .white : .black)
//                .frame(maxWidth: .infinity)
//                .frame(height: 44)
//                .background(isSelected ? Color(
//                    red: 234/255,
//                    green: 121/255,
//                    blue: 97/255
//                ) : Color.gray.opacity(0.1))
//                .cornerRadius(12)
//        }
//        .buttonStyle(.plain)
//    }
//}

struct HeightRuler: View {
    @Binding var value: Double
    let minValue: Double
    let maxValue: Double
    let unit: String
    
    @State private var dragOffset: CGFloat = 0
    private let stepHeight: CGFloat = 4
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                
                VStack(spacing: 0) {
                    ForEach((Int(minValue)...Int(maxValue)).reversed(), id: \.self) { height in
                        HStack(alignment: .center, spacing: 4) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: height % 5 == 0 ? 15 : 8, height: 2)
                            
                            if height % 5 == 0 {
                                Text("\(height)")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(height: stepHeight)
                    }
                }
                .offset(y: dragOffset + geometry.size.height / 2 - CGFloat(maxValue - value) * stepHeight)
                
                Rectangle()
                    .fill(Color(
                        red: 234/255,
                        green: 121/255,
                        blue: 97/255
                    ))
                    .frame(width: 20, height: 2)
                    .position(x: 10, y: geometry.size.height / 2)
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let translation = gesture.translation.height
                        dragOffset = translation
                        
                        let steps = translation / stepHeight
                        let newValue = value + Double(steps)
                        
                        let clampedValue = min(maxValue, max(minValue, newValue))
                        
                        if abs(clampedValue - value) > 0.01 {
                            value = clampedValue
                        }
                    }
                    .onEnded { _ in
                        value = round(value)
                        
                        withAnimation(.spring()) {
                            dragOffset = 0
                        }
                    }
            )
        }
        .clipped()
    }
}

#Preview {
    HeightInputView()
}

