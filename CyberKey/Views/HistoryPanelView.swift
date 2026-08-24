//
//  HistoryPanelView.swift
//  CyberKey
//
//  Copyright © 2026 Cybergroup Incorporated
//

import SwiftUI

struct HistoryPanelView: View {
    let history: [DetectionResult]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DETECTION LOG")
                .font(CyberpunkTheme.neonCaption(10))
                .foregroundStyle(CyberpunkTheme.electricPurple.opacity(0.8))
                .tracking(2)
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(history.prefix(12)) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.key.shortName)
                                .font(CyberpunkTheme.neonBody(13))
                                .foregroundStyle(CyberpunkTheme.neonCyan)
                            
                            if let chord = item.chord {
                                Text(chord.displayName)
                                    .font(CyberpunkTheme.neonCaption(12))
                                    .foregroundStyle(CyberpunkTheme.hotMagenta)
                            } else {
                                Text("—")
                                    .font(CyberpunkTheme.neonCaption(12))
                                    .foregroundStyle(.gray)
                            }
                            
                            Text(item.timestamp, style: .time)
                                .font(CyberpunkTheme.neonCaption(9))
                                .foregroundStyle(.gray.opacity(0.7))
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.45))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(CyberpunkTheme.neonCyan.opacity(0.2), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(CyberpunkTheme.panelBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(CyberpunkTheme.electricPurple.opacity(0.25), lineWidth: 1)
                )
        )
    }
}
