//
//  FinishView.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import SwiftUI

struct FinishView: View {
    @StateObject private var viewModel = FinishViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                    
                    // Progress bar (centered) - 100% complete
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
                .padding(.bottom, 40)
                
                Spacer()
                
                // Finish content
                VStack(spacing: 24) {
                    // Success icon or image
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color(
                            red: 147/255,
                            green: 27/255,
                            blue: 255/255
                        ))
                    
                    Text("Finish")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("You're all set! Let's start your journey.")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Finish/Get Started button
                Button(action: {
                    viewModel.handleFinish()
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
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    FinishView()
}

