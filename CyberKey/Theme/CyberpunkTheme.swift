//
//  CyberpunkTheme.swift
//  CyberKey
//
//  Cyberpunk UIX designed by Cybergroup Incorporated
//

import SwiftUI

struct CyberpunkTheme {
    // MARK: - Core Colors
    static let voidBlack = Color(red: 0.02, green: 0.02, blue: 0.05)
    static let deepVoid = Color(red: 0.04, green: 0.04, blue: 0.09)
    static let neonCyan = Color(red: 0.0, green: 0.94, blue: 1.0)       // #00F0FF
    static let hotMagenta = Color(red: 1.0, green: 0.0, blue: 0.67)     // #FF00AA
    static let electricPurple = Color(red: 0.55, green: 0.0, blue: 1.0) // #8C00FF
    static let neonGreen = Color(red: 0.2, green: 1.0, blue: 0.4)
    static let warningYellow = Color(red: 1.0, green: 0.85, blue: 0.0)
    
    static let panelBackground = Color.black.opacity(0.55)
    static let gridLine = Color.white.opacity(0.06)
    
    // MARK: - Gradients
    static let neonGradient = LinearGradient(
        colors: [neonCyan, electricPurple, hotMagenta],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cyanMagenta = LinearGradient(
        colors: [neonCyan, hotMagenta],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // MARK: - Text Styles
    static func neonTitle(_ size: CGFloat = 42) -> Font {
        .system(size: size, weight: .black, design: .monospaced)
    }
    
    static func neonBody(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .medium, design: .monospaced)
    }
    
    static func neonCaption(_ size: CGFloat = 12) -> Font {
        .system(size: size, weight: .regular, design: .monospaced)
    }
}

// MARK: - Neon Glow Modifier
struct NeonGlow: ViewModifier {
    var color: Color = CyberpunkTheme.neonCyan
    var radius: CGFloat = 12
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.9), radius: radius / 2)
            .shadow(color: color.opacity(0.6), radius: radius)
            .shadow(color: color.opacity(0.3), radius: radius * 1.8)
    }
}

extension View {
    func neonGlow(_ color: Color = CyberpunkTheme.neonCyan, radius: CGFloat = 12) -> some View {
        modifier(NeonGlow(color: color, radius: radius))
    }
}

// MARK: - Scanline Overlay
struct ScanlineOverlay: View {
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                let lineHeight: CGFloat = 3
                let spacing: CGFloat = 6
                var y: CGFloat = offset.truncatingRemainder(dividingBy: spacing)
                while y < size.height {
                    let rect = CGRect(x: 0, y: y, width: size.width, height: lineHeight)
                    context.fill(Path(rect), with: .color(.white.opacity(0.03)))
                    y += spacing
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                    offset = 200
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Grid Background
struct CyberGridBackground: View {
    var body: some View {
        Canvas { context, size in
            let step: CGFloat = 28
            
            // Vertical lines
            var x: CGFloat = 0
            while x < size.width {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(CyberpunkTheme.gridLine), lineWidth: 1)
                x += step
            }
            
            // Horizontal lines
            var y: CGFloat = 0
            while y < size.height {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(CyberpunkTheme.gridLine), lineWidth: 1)
                y += step
            }
        }
        .background(CyberpunkTheme.voidBlack)
    }
}
