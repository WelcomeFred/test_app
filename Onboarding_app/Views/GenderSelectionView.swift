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
                        color: Color(
                            red: 147/255,
                            green: 27/255,
                            blue: 255/255
                        )                    ) {
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
                .padding(.bottom, 40)
                
                // Prefer not to say button
                Button(action: {
//                    viewModel.selectGender(.preferNotToSay)
                    print("Prefer not to say")
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
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
struct GenderCard: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    private let radius: CGFloat = 24

    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .cornerRadius(radius)
                        .clipped()

                    if isSelected {
                        ZStack {
                            Triangle()
                                .fill(color)
                                .frame(width: 60, height: 60)

                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                                .offset(x: 10, y: -10)
                        }
                    }
                }

                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(isSelected ? color : Color.clear)
            }
            .padding(8)
            .background(isSelected ? color : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(
                        isSelected ? color : Color.gray.opacity(0.3),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        return path
    }
}



#Preview {
    GenderSelectionView()
}

