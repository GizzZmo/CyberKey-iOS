//
//  SpectrumVisualizerView.swift
//  CyberKey
//
//  Copyright © 2026 Cybergroup Incorporated
//

import SwiftUI

struct SpectrumVisualizerView: View {
    let chroma: [Double]
    let level: Float
    
    private let noteLabels = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<12, id: \.self) { i in
                    let height = max(0.05, chroma.indices.contains(i) ? chroma[i] : 0)
                    
                    VStack(spacing: 3) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        CyberpunkTheme.neonCyan,
                                        CyberpunkTheme.electricPurple,
                                        CyberpunkTheme.hotMagenta
                                    ],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(height: 70 * height)
                            .neonGlow(i % 2 == 0 ? CyberpunkTheme.neonCyan : CyberpunkTheme.hotMagenta, radius: 4)
                        
                        Text(noteLabels[i])
                            .font(CyberpunkTheme.neonCaption(9))
                            .foregroundStyle(Color.white.opacity(0.55))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(CyberpunkTheme.panelBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(CyberpunkTheme.electricPurple.opacity(0.3), lineWidth: 1)
                    )
            )
            
            // Overall energy
            HStack {
                Text("ENERGY")
                    .font(CyberpunkTheme.neonCaption(9))
                    .foregroundStyle(.gray)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.08))
                        Capsule()
                            .fill(CyberpunkTheme.neonGradient)
                            .frame(width: geo.size.width * CGFloat(level))
                    }
                }
                .frame(height: 4)
            }
            .padding(.horizontal, 4)
        }
    }
}
