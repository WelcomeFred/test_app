//
//  GenderSelectionView.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import SwiftUI

struct GenderSelectionView: View {
    @StateObject private var viewModel = GenderSelectionViewModel()
    @Environment(\.dismiss) var dismiss
    
    private var progressBarColor: Color {
        switch viewModel.selectedGender {
        case .female:
            return .purple
        case .male:
            return .orange
        default:
            return .orange
        }
    }
    
    var body: some View {
        ZStack {
            // Main background
            Color(red: 0.96, green: 0.95, blue: 0.93)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation bar with back button and progress bar
                VStack(spacing: 16) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 4)
                                .cornerRadius(2)
                            
                            Rectangle()
                                .fill(progressBarColor)
                                .frame(width: geometry.size.width * 0.5, height: 4)
                                .cornerRadius(2)
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 32)
                
                // Title and subtitle
                VStack(spacing: 8) {
                    Text("Choose your gender")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("This will be used to calibrate your custom plan")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
                
                // Gender selection cards
                HStack(spacing: 16) {
                    // Female card
                    GenderCard(
                        imageName: "female",
                        title: "Female",
                        isSelected: viewModel.selectedGender == .female,
                        color: .purple
                    ) {
                        viewModel.selectGender(.female)
                    }
                    
                    // Male card
                    GenderCard(
                        imageName: "male",
                        title: "Male",
                        isSelected: viewModel.selectedGender == .male,
                        color: .orange
                    ) {
                        viewModel.selectGender(.male)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                // Prefer not to say button
                Button(action: {
                    viewModel.selectGender(.preferNotToSay)
                }) {
                    Text("Prefer not to say?")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.gray.opacity(0.1))
                }
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
                        .background(viewModel.selectedGender != nil ? Color.black : Color.gray.opacity(0.3))
                        .cornerRadius(12)
                }
                .disabled(viewModel.selectedGender == nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct GenderCard: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(16)
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(color)
                            .font(.system(size: 24))
                            .padding(8)
                    }
                }
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            .padding(10)
            .background(isSelected ? color.opacity(0.1) : Color.gray.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? color : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    GenderSelectionView()
}

