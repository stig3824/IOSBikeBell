//
//  ContentView.swift
//  BikeBell
//
//  Created by Nicholas Spackman on 25/4/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var motionManager = MotionManager()
    @StateObject var soundManager = SoundManager()
    @AppStorage("sensitivity") var sensitivity: Double = 100 // Persist sensitivity setting
    @AppStorage("threshold") var threshold: Double = 11   // Persist threshold setting
    @State var isRinging = false
    @State var showingSettings = false
    @State var ringScale: CGFloat = 0.0
    @State var showingError = false
    @State var errorMessage = ""
    
    var body: some View {
        ZStack {
            // Black background
            Color.black.ignoresSafeArea()
            
            VStack {
                // Settings button in top right
                HStack {
                    Spacer()
                    Button(action: {
                        showingSettings.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                Spacer()
                
                // Main bell display (no longer a button)
                BellAnimationView(
                    isRinging: isRinging,
                    isActive: motionManager.isActive
                )
                
                Spacer()
                
                // Status indicator
                HStack(spacing: 12) {
                    Text("ON")
                        .foregroundColor(motionManager.isActive ? .green : .gray)
                        .font(.title)
                    Text("/")
                        .foregroundColor(.gray)
                        .font(.title)
                    Text("OFF")
                        .foregroundColor(motionManager.isActive ? .gray : .red)
                        .font(.title)
                }
                .padding(.bottom, 8)
                
                // Tap hint
                Text("Tap anywhere to toggle")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 16)
            }
        }
        .onTapGesture {
            // Toggle motion detection when tapping anywhere on the screen
            if motionManager.isActive {
                motionManager.stopUpdates()
            } else {
                do {
                    try motionManager.startUpdates()
                } catch {
                    errorMessage = "Failed to start motion detection: \(error.localizedDescription)"
                    showingError = true
                }
            }
        }
        .onAppear {
            // Set up preview notification handlers
            NotificationCenter.default.addObserver(
                forName: Notification.Name("PreviewStartMotionUpdates"),
                object: nil,
                queue: .main
            ) { _ in
                do {
                    try motionManager.startUpdates()
                } catch {
                    errorMessage = "Failed to start motion detection: \(error.localizedDescription)"
                    showingError = true
                }
            }
            
            NotificationCenter.default.addObserver(
                forName: Notification.Name("PreviewTriggerRing"),
                object: nil,
                queue: .main
            ) { _ in
                motionManager.acceleration = 2.0
            }
            
            NotificationCenter.default.addObserver(
                forName: Notification.Name("PreviewShowSettings"),
                object: nil,
                queue: .main
            ) { _ in
                showingSettings = true
            }
        }
        .onChange(of: motionManager.acceleration) { oldValue, newValue in
            // Map threshold from 0-100 to 0.1-2.0
            let mappedThreshold = (threshold / 100.0) * 1.9 + 0.1
            // Map sensitivity from 0-100 to 0.1-1.5
            let mappedSensitivity = (sensitivity / 100.0) * 1.4 + 0.1
            
            if newValue > mappedThreshold {
                do {
                    try soundManager.playBell(intensity: (newValue - mappedThreshold) * mappedSensitivity)
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isRinging = true
                        ringScale = min(newValue / mappedThreshold, 1.0)
                    }
                    
                    // Reset the animation after a longer delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            isRinging = false
                            ringScale = 0.0
                        }
                    }
                } catch {
                    errorMessage = "Failed to play bell sound: \(error.localizedDescription)"
                    showingError = true
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            NavigationView {
                ZStack {
                    Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1E dark charcoal - match reference
                        .ignoresSafeArea()
                    
                    List {
                        Section(header: Text("SENSITIVITY").font(.headline).fontWeight(.medium).foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.92)).padding(.bottom, 8)) { // Smaller section header like reference
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Motion Threshold")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(Int(threshold))%")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                Slider(value: $threshold, in: 0...100)
                                    .tint(Color(red: 0.0, green: 0.48, blue: 1.0)) // #007AFF blue
                                Text("Higher values make the bell less sensitive to motion")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67)) // #AAAAAA lighter gray
                                    .padding(.top, 4)
                            }
                            .listRowBackground(Color(red: 0.22, green: 0.22, blue: 0.24)) // Darker gray for better contrast
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Sound Intensity")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(Int(sensitivity))%")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                Slider(value: $sensitivity, in: 0...100)
                                    .tint(Color(red: 0.20, green: 0.78, blue: 0.35)) // #34C759 green
                                Text("Adjusts how loud the bell rings")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67)) // #AAAAAA lighter gray
                                    .padding(.top, 4)
                            }
                            .listRowBackground(Color(red: 0.22, green: 0.22, blue: 0.24)) // Darker gray for better contrast
                        }
                        .listSectionSpacing(20) // Add spacing between sections
                        
                        Section(header: Text("BELL TYPE").font(.headline).fontWeight(.medium).foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.92)).padding(.bottom, 8)) { // Smaller section header like reference
                            Picker("Bell Sound", selection: $soundManager.currentBellType) {
                                ForEach(BellType.allCases, id: \.self) { bellType in
                                    Text(bellType.rawValue)
                                        .foregroundColor(.white)
                                        .tag(bellType)
                                }
                            }
                            .pickerStyle(.segmented)
                            .listRowBackground(Color(red: 0.22, green: 0.22, blue: 0.24))
                            .accentColor(.white)
                            .colorScheme(.dark)
                        }
                        
                        Section {
                            Button(action: {
                                threshold = 11
                                sensitivity = 100
                            }) {
                                HStack {
                                    Text("Reset to Default Settings")
                                        .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0)) // #007AFF light blue
                                    Spacer()
                                    Image(systemName: "arrow.counterclockwise")
                                        .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0)) // #007AFF light blue
                                }
                            }
                            .listRowBackground(Color(red: 0.22, green: 0.22, blue: 0.24)) // Darker gray for better contrast
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12)) // #1C1C1E dark charcoal - match reference
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(trailing: Button("Done") {
                    showingSettings = false
                }
                .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0))) // #007AFF light blue
                .toolbarBackground(Color(red: 0.11, green: 0.11, blue: 0.12), for: .navigationBar) // #1C1C1E dark charcoal - match reference
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") {
                showingError = false
            }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    ContentView()
}
