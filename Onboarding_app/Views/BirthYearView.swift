//
//  BirthYearView.swift
//  Onboarding_app
//
//  Created by Fred Sargsyan on 06.01.26.
//

import SwiftUI

struct BirthYearView: View {
    @StateObject private var viewModel = BirthYearViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            birthYearContent
                .navigationDestination(isPresented: $viewModel.shouldNavigateToNext) {
                    GoalSelectionView()
                }
        }
    }
    
    private var birthYearContent: some View {
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
                Text("What year were you born?")
                    .font(.system(size: 22, weight: .bold, design: .serif))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                
                // Year picker
                YearPicker(
                    selectedYear: $viewModel.selectedYear,
                    minYear: viewModel.minYear,
                    maxYear: viewModel.maxYear
                )
                .frame(maxHeight: .infinity)
                
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

struct YearPicker: View {
    @Binding var selectedYear: Int
    let minYear: Int
    let maxYear: Int
    
    @State private var scrollProxy: ScrollViewProxy?
    private let itemHeight: CGFloat = 50
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradients for fade effect
                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [.white.opacity(0.95), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geometry.size.height / 3)
                    
                    Spacer()
                    
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.95)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geometry.size.height / 3)
                }
                .allowsHitTesting(false)
                
                // Scrollable years
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach((minYear...maxYear).reversed(), id: \.self) { year in
                                YearItem(
                                    year: year,
                                    isSelected: year == selectedYear
                                )
                                .frame(height: itemHeight)
                                .id(year)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedYear = year
                                        proxy.scrollTo(year, anchor: .center)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, geometry.size.height / 2 - itemHeight / 2)
                    }
                    .onAppear {
                        scrollProxy = proxy
                        // Scroll to initial year
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                proxy.scrollTo(selectedYear, anchor: .center)
                            }
                        }
                    }
                    .onChange(of: selectedYear) { newYear in
                        // Smooth scroll when year changes from external source
                        withAnimation(.spring()) {
                            proxy.scrollTo(newYear, anchor: .center)
                        }
                    }
                }
                .mask(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .black,
                            .black,
                            .clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // Selection indicator
                VStack(spacing: 0) {
                    Spacer()

                    
//                    Spacer()
                        .frame(height: itemHeight)
                    
                    
                    
                    Spacer()
                }
                .allowsHitTesting(false)
            }
        }
        .clipped()
    }
}
struct YearItem: View {
    let year: Int
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 40)
            }
            
            Text("\(year)")
                .font(.system(size: isSelected ? 24 : 18, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .black : .gray.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    BirthYearView()
}

