//
//  MusicalKey.swift
//  CyberKey
//
//  Copyright © 2026 Cybergroup Incorporated
//

import Foundation

enum KeyMode: String, CaseIterable, Codable {
    case major = "Major"
    case minor = "Minor"
    
    var short: String {
        switch self {
        case .major: return "maj"
        case .minor: return "min"
        }
    }
}

struct MusicalKey: Identifiable, Equatable, Codable {
    let id = UUID()
    let root: Int          // 0 = C, 1 = C#, ... 11 = B
    let mode: KeyMode
    var confidence: Double // 0.0 – 1.0
    
    static let noteNames = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    static let noteNamesFlat = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    var displayName: String {
        "\(MusicalKey.noteNames[root]) \(mode.rawValue)"
    }
    
    var shortName: String {
        "\(MusicalKey.noteNames[root])\(mode == .major ? "" : "m")"
    }
    
    var relativeMinorRoot: Int {
        (root + 9) % 12
    }
    
    var relativeMajorRoot: Int {
        (root + 3) % 12
    }
    
    // Temperley key profiles (normalized)
    static let majorProfile: [Double] = [
        5.0, 2.0, 3.5, 2.0, 4.5, 4.0, 2.0, 4.5, 2.0, 3.5, 1.5, 4.0
    ].map { $0 / 38.5 }
    
    static let minorProfile: [Double] = [
        5.0, 2.0, 3.5, 4.5, 2.0, 4.0, 2.0, 4.5, 3.5, 2.0, 1.5, 4.0
    ].map { $0 / 38.5 }
    
    static func detect(from chroma: [Double]) -> MusicalKey {
        guard chroma.count == 12 else {
            return MusicalKey(root: 0, mode: .major, confidence: 0)
        }
        
        var bestKey = MusicalKey(root: 0, mode: .major, confidence: 0)
        var bestScore: Double = -1
        
        for root in 0..<12 {
            // Major
            let majorScore = correlation(chroma: chroma, profile: majorProfile, root: root)
            if majorScore > bestScore {
                bestScore = majorScore
                bestKey = MusicalKey(root: root, mode: .major, confidence: max(0, min(1, majorScore)))
            }
            
            // Minor
            let minorScore = correlation(chroma: chroma, profile: minorProfile, root: root)
            if minorScore > bestScore {
                bestScore = minorScore
                bestKey = MusicalKey(root: root, mode: .minor, confidence: max(0, min(1, minorScore)))
            }
        }
        
        return bestKey
    }
    
    private static func correlation(chroma: [Double], profile: [Double], root: Int) -> Double {
        var rotated = [Double](repeating: 0, count: 12)
        for i in 0..<12 {
            rotated[i] = profile[(i - root + 12) % 12]
        }
        
        // Pearson correlation
        let meanC = chroma.reduce(0, +) / 12
        let meanP = rotated.reduce(0, +) / 12
        
        var num: Double = 0
        var denC: Double = 0
        var denP: Double = 0
        
        for i in 0..<12 {
            let dc = chroma[i] - meanC
            let dp = rotated[i] - meanP
            num += dc * dp
            denC += dc * dc
            denP += dp * dp
        }
        
        let den = sqrt(denC * denP)
        return den > 0 ? num / den : 0
    }
}
