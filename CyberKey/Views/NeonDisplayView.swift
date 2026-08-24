//
//  NeonDisplayView.swift
//  CyberKey
//
//  Copyright © 2026 Cybergroup Incorporated
//

import SwiftUI

struct NeonDisplayView: View {
    let key: MusicalKey
    let chord: Chord?
    let isListening: Bool
    
    var body: some View {
        VStack(spacing: 28) {
            // KEY section
            VStack(spacing: 6) {
                Text("TONEART / KEY")
                    .font(CyberpunkTheme.neonCaption(11))
                    .foregroundStyle(CyberpunkTheme.neonCyan.opacity(0.7))
                    .tracking(3)
                
                Text(key.displayName)
                    .font(CyberpunkTheme.neonTitle(48))
                    .foregroundStyle(CyberpunkTheme.neonCyan)
                    .neonGlow(CyberpunkTheme.neonCyan, radius: 16)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                
                // Confidence bar
                confidenceBar(value: key.confidence, color: CyberpunkTheme.neonCyan)
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(CyberpunkTheme.panelBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(CyberpunkTheme.neonCyan.opacity(0.35), lineWidth: 1.5)
                    )
            )
            .padding(.horizontal, 20)
            
            // CHORD section
            VStack(spacing: 6) {
                Text("CURRENT CHORD")
                    .font(CyberpunkTheme.neonCaption(11))
                    .foregroundStyle(CyberpunkTheme.hotMagenta.opacity(0.7))
                    .tracking(3)
                
                Text(chord?.displayName ?? "—")
                    .font(CyberpunkTheme.neonTitle(56))
                    .foregroundStyle(chord != nil ? CyberpunkTheme.hotMagenta : Color.gray.opacity(0.4))
                    .neonGlow(chord != nil ? CyberpunkTheme.hotMagenta : .clear, radius: 18)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                if let c = chord {
                    confidenceBar(value: c.confidence, color: CyberpunkTheme.hotMagenta)
                } else {
                    Text(isListening ? "Listening for harmony…" : "Start listening")
                        .font(CyberpunkTheme.neonCaption(12))
                        .foregroundStyle(.gray)
                }
            }
            .padding(.vertical, 22)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(CyberpunkTheme.panelBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(CyberpunkTheme.hotMagenta.opacity(0.35), lineWidth: 1.5)
                    )
            )
            .padding(.horizontal, 20)
        }
    }
    
    private func confidenceBar(value: Double, color: Color) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.08))
                Capsule()
                    .fill(color.opacity(0.85))
                    .frame(width: max(4, geo.size.width * CGFloat(value)))
                    .neonGlow(color, radius: 4)
            }
        }
        .frame(height: 5)
        .padding(.top, 4)
    }
}
