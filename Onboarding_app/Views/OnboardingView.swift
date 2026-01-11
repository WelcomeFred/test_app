//
//  OnboardingView.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationStack {
            onboardingContent
                .navigationDestination(isPresented: $viewModel.shouldShowGenderSelection) {
                    GenderSelectionView()
                }
        }
    }
    
    private var onboardingContent: some View {
        ZStack {
            // Main background
            Color(red: 0.96, green: 0.95, blue: 0.93)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                            Image("launch")
                                .resizable()
                                .scaledToFit()
                                .frame(height: UIScreen.main.bounds.height * 0.609)
                
                // Bottom section with text and button
                VStack(spacing: 22) {
                    // Page indicators
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                        
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 20, height: 8)
                            .cornerRadius(10)
                        
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                    .padding(.top, 32)
                    
                    // Headline
                    Text("Calories tracking made easy")
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .padding(.horizontal, 32)
                    
                    
                    // Description
                    Text("take a picture, we analyse everything for you.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        .padding(.horizontal, 0)
                    
                    Spacer(minLength: 0)
                    
                    ZStack {
                        Color.white

                        VStack {
                            Spacer()
                                .frame(maxHeight: .infinity)
                                .layoutPriority(2)

                            Button(action: {
                                viewModel.handleGetStarted()
                            }) {
                                Text("Get Started")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(Color.black)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 32)
                            .padding(.bottom, 40)

                            Spacer()
                                .frame(maxHeight: .infinity)
                                .layoutPriority(3)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.96, green: 0.95, blue: 0.93))
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    OnboardingView()
}

