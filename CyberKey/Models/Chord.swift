//
//  Chord.swift
//  CyberKey
//
//  Copyright © 2026 Cybergroup Incorporated
//

import Foundation

struct Chord: Identifiable, Equatable, Codable {
    let id = UUID()
    let root: Int              // 0-11
    let quality: String        // "maj", "min", "7", "maj7", "min7", "dim", "aug", "sus2", "sus4", etc.
    var confidence: Double
    
    var displayName: String {
        let rootName = MusicalKey.noteNames[root]
        switch quality {
        case "maj": return rootName
        case "min": return "\(rootName)m"
        case "7": return "\(rootName)7"
        case "maj7": return "\(rootName)maj7"
        case "min7": return "\(rootName)m7"
        case "dim": return "\(rootName)dim"
        case "aug": return "\(rootName)aug"
        case "sus2": return "\(rootName)sus2"
        case "sus4": return "\(rootName)sus4"
        case "min7b5": return "\(rootName)m7♭5"
        default: return "\(rootName)\(quality)"
        }
    }
    
    // Chord templates as pitch-class vectors (root = 0)
    static let templates: [(quality: String, vector: [Double])] = [
        ("maj",   [1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0]),
        ("min",   [1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0]),
        ("7",     [1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0]),
        ("maj7",  [1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1]),
        ("min7",  [1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0]),
        ("dim",   [1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0]),
        ("aug",   [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]),
        ("sus2",  [1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0]),
        ("sus4",  [1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0]),
        ("min7b5",[1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0]),
    ]
    
    static func recognize(from chroma: [Double], threshold: Double = 0.55) -> Chord? {
        guard chroma.count == 12 else { return nil }
        
        // Normalize chroma
        let sum = chroma.reduce(0, +)
        guard sum > 0.01 else { return nil }
        let norm = chroma.map { $0 / sum }
        
        var best: Chord?
        var bestScore: Double = threshold
        
        for root in 0..<12 {
            for template in templates {
                var rotated = [Double](repeating: 0, count: 12)
                for i in 0..<12 {
                    rotated[i] = template.vector[(i - root + 12) % 12]
                }
                
                // Cosine similarity
                let score = cosineSimilarity(norm, rotated)
                if score > bestScore {
                    bestScore = score
                    best = Chord(root: root, quality: template.quality, confidence: score)
                }
            }
        }
        
        return best
    }
    
    private static func cosineSimilarity(_ a: [Double], _ b: [Double]) -> Double {
        var dot: Double = 0
        var normA: Double = 0
        var normB: Double = 0
        for i in 0..<12 {
            dot += a[i] * b[i]
            normA += a[i] * a[i]
            normB += b[i] * b[i]
        }
        let den = sqrt(normA * normB)
        return den > 0 ? dot / den : 0
    }
}
