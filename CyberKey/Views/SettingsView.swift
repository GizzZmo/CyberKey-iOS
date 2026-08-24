//
//  SettingsView.swift
//  CyberKey
//
//  Copyright © 2026 Cybergroup Incorporated
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var engine: AudioEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                CyberpunkTheme.voidBlack.ignoresSafeArea()
                
                List {
                    Section {
                        HStack {
                            Text("Status")
                            Spacer()
                            Text(engine.isRunning ? "Listening" : "Stopped")
                                .foregroundStyle(engine.isRunning ? CyberpunkTheme.neonGreen : .gray)
                        }
                        
                        HStack {
                            Text("Input Level")
                            Spacer()
                            Text(String(format: "%.0f%%", engine.inputLevel * 100))
                                .foregroundStyle(CyberpunkTheme.neonCyan)
                        }
                    } header: {
                        Text("ENGINE")
                            .foregroundStyle(CyberpunkTheme.neonCyan)
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                    
                    Section {
                        Text("CyberKey uses the device microphone or any connected audio interface (USB-C, Lightning, Bluetooth) on iPhone 17 Pro.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        Text("All analysis is performed on-device. No audio is recorded or uploaded.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    } header: {
                        Text("AUDIO INPUT")
                            .foregroundStyle(CyberpunkTheme.hotMagenta)
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                    
                    Section {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CyberKey")
                                .font(.headline)
                                .foregroundStyle(CyberpunkTheme.neonCyan)
                            Text("Version 1.0.0")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Cyberpunk UIX by Cybergroup Incorporated")
                                .font(.caption)
                                .foregroundStyle(CyberpunkTheme.hotMagenta)
                            Text("Optimized for iPhone 17 Pro • iOS 26")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    } header: {
                        Text("ABOUT")
                            .foregroundStyle(CyberpunkTheme.electricPurple)
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(CyberpunkTheme.neonCyan)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
