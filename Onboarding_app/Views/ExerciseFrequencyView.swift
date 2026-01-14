//
//  ExerciseFrequencyView.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import SwiftUI

struct ExerciseFrequencyView: View {
    @StateObject private var viewModel = ExerciseFrequencyViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            exerciseFrequencyContent
                .navigationDestination(isPresented: $viewModel.shouldNavigateToNext) {
                    WeightInputView()
                }
        }
    }
    
    private var exerciseFrequencyContent: some View {
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
                .padding(.bottom, 40)
                
                // Question
                Text("How often do you excersise?")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                
                // Exercise frequency options
                VStack(spacing: 16) {
                    ForEach(viewModel.options) { option in
                        ExerciseOptionCard(
                            option: option,
                            isSelected: viewModel.selectedOption?.id == option.id,
                            selectedDays: viewModel.selectedDays[option.id] ?? [],
                            onSelect: {
                                viewModel.selectOption(option)
                            },
                            onDayToggle: { day in
                                viewModel.toggleDay(for: option.id, day: day)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                
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
                        .background(viewModel.selectedOption != nil ? Color.black : Color.gray.opacity(0.3))
                        .cornerRadius(12)
                }
                .disabled(viewModel.selectedOption == nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct ExerciseOption: Identifiable {
    let id: Int
    let title: String
    let frequency: String
    let defaultDays: [Int] // Day indices (0 = Monday, 6 = Sunday)
}

struct ExerciseOptionCard: View {
    let option: ExerciseOption
    let isSelected: Bool
    let selectedDays: [Int]
    let onSelect: () -> Void
    let onDayToggle: (Int) -> Void
    
    // Days in the order shown in design: Mon, Thu, Tue, Wed, Fri, Sat, Sun
    private let dayLabels = ["Mon", "Thu", "Tue", "Wed", "Fri", "Sat", "Sun"]
    private let dayIndexMapping = [0, 3, 1, 2, 4, 5, 6] // Maps display order to actual day indices
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(option.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(option.frequency)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                }
                
                // Days of week with checkboxes
                HStack(spacing: 8) {
                    ForEach(Array(dayLabels.enumerated()), id: \.offset) { index, dayLabel in
                        let dayIndex = dayIndexMapping[index]
                        DayCheckbox(
                            day: dayLabel,
                            isSelected: selectedDays.contains(dayIndex),
                            onToggle: {
                                onDayToggle(dayIndex)
                            }
                        )
                    }
                }
            }
            .padding(20)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct DayCheckbox: View {
    let day: String
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            VStack(spacing: 4) {
                Text(day)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .black : .gray)
                
                Rectangle()
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.3))
                    .frame(height: isSelected ? 3 : 1)
            }
            .frame(width: 40)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ExerciseFrequencyView()
}

