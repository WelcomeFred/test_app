//
//  GoalSelectionView.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import SwiftUI

struct GoalSelectionView: View {
    @StateObject private var viewModel = GoalSelectionViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            goalSelectionContent
                .navigationDestination(isPresented: $viewModel.shouldNavigateToNext) {
                    TargetWeightView()
                }
        }
    }
    
    private var goalSelectionContent: some View {
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
                    Text("What is your goal?")
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
                
                // Goal options
                VStack(spacing: 16) {
                    ForEach(viewModel.goals) { goal in
                        GoalOptionCard(
                            goal: goal,
                            isSelected: viewModel.selectedGoal?.id == goal.id,
                            onSelect: {
                                viewModel.selectGoal(goal)
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
                        .background(viewModel.selectedGoal != nil ? Color.black : Color.gray.opacity(0.3))
                        .cornerRadius(12)
                }
                .disabled(viewModel.selectedGoal == nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct Goal: Identifiable {
    let id: Int
    let title: String
    let iconName: String
    let color: Color
}

struct GoalOptionCard: View {
    let goal: Goal
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Icon
                Image(goal.iconName)
                    .font(.system(size: 24))
                    .foregroundColor(goal.color)
                    .frame(width: 40, height: 40)
                
                // Title
                Text(goal.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Checkmark when selected
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(goal.color)
                        .padding(8)
                }
            }
            .padding(20)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? goal.color : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    GoalSelectionView()
}

