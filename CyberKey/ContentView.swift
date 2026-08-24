//
//  ContentView.swift
//  CyberKey
//
//  Cyberpunk UIX by Cybergroup Incorporated
//  Copyright © 2026 Cybergroup Incorporated
//

import SwiftUI

struct ContentView: View {
    @StateObject private var engine = AudioEngine()
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            // Background
            CyberGridBackground()
                .ignoresSafeArea()
            
            ScanlineOverlay()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                header
                
                Spacer(minLength: 12)
                
                // Main Neon Displays
                NeonDisplayView(
                    key: engine.currentKey,
                    chord: engine.currentChord,
                    isListening: engine.isRunning
                )
                
                Spacer(minLength: 16)
                
                // Spectrum / Chroma visualizer
                SpectrumVisualizerView(chroma: engine.chroma, level: engine.inputLevel)
                    .frame(height: 110)
                    .padding(.horizontal, 20)
                
                Spacer(minLength: 12)
                
                // History
                if !engine.history.isEmpty {
                    HistoryPanelView(history: engine.history)
                        .frame(maxHeight: 140)
                        .padding(.horizontal, 16)
                }
                
                Spacer(minLength: 8)
                
                // Controls
                controls
                    .padding(.bottom, 28)
            }
            .padding(.top, 8)
        }
        .alert("Audio Error", isPresented: .constant(engine.errorMessage != nil)) {
            Button("OK") { engine.errorMessage = nil }
        } message: {
            Text(engine.errorMessage ?? "")
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(engine: engine)
        }
        .task {
            await engine.requestPermissionAndStart()
        }
    }
    
    // MARK: - Header
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("CYBERKEY")
                    .font(CyberpunkTheme.neonTitle(22))
                    .foregroundStyle(CyberpunkTheme.neonCyan)
                    .neonGlow(CyberpunkTheme.neonCyan, radius: 8)
                
                Text("by Cybergroup Incorporated")
                    .font(CyberpunkTheme.neonCaption(10))
                    .foregroundStyle(CyberpunkTheme.hotMagenta.opacity(0.8))
            }
            
            Spacer()
            
            // Status indicator
            HStack(spacing: 6) {
                Circle()
                    .fill(engine.isRunning ? CyberpunkTheme.neonGreen : Color.gray)
                    .frame(width: 8, height: 8)
                    .neonGlow(engine.isRunning ? CyberpunkTheme.neonGreen : .clear, radius: 6)
                
                Text(engine.isRunning ? "LIVE" : "OFF")
                    .font(CyberpunkTheme.neonCaption(11))
                    .foregroundStyle(engine.isRunning ? CyberpunkTheme.neonGreen : .gray)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .stroke(engine.isRunning ? CyberpunkTheme.neonGreen.opacity(0.6) : Color.gray.opacity(0.4), lineWidth: 1)
            )
            
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(CyberpunkTheme.neonCyan)
            }
            .padding(.leading, 8)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
    
    // MARK: - Controls
    private var controls: some View {
        HStack(spacing: 24) {
            Button {
                if engine.isRunning {
                    engine.stop()
                } else {
                    Task { await engine.requestPermissionAndStart() }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: engine.isRunning ? "stop.fill" : "mic.fill")
                    Text(engine.isRunning ? "STOP" : "LISTEN")
                        .font(CyberpunkTheme.neonBody(14))
                }
                .foregroundStyle(CyberpunkTheme.voidBlack)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(engine.isRunning ? CyberpunkTheme.hotMagenta : CyberpunkTheme.neonCyan)
                        .neonGlow(engine.isRunning ? CyberpunkTheme.hotMagenta : CyberpunkTheme.neonCyan, radius: 10)
                )
            }
            
            // Level meter mini
            VStack(spacing: 4) {
                Text("INPUT")
                    .font(CyberpunkTheme.neonCaption(9))
                    .foregroundStyle(.gray)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                        Capsule()
                            .fill(CyberpunkTheme.cyanMagenta)
                            .frame(width: geo.size.width * CGFloat(engine.inputLevel))
                    }
                }
                .frame(width: 80, height: 6)
            }
        }
    }
}

#Preview {
    ContentView()
}
