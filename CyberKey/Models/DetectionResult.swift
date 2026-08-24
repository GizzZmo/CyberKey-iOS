//
//  DetectionResult.swift
//  CyberKey
//
//  Copyright © 2026 Cybergroup Incorporated
//

import Foundation

struct DetectionResult: Identifiable, Equatable {
    let id = UUID()
    let timestamp: Date
    let key: MusicalKey
    let chord: Chord?
    let chroma: [Double]
    
    var keyConfidencePercent: Int {
        Int(key.confidence * 100)
    }
    
    var chordConfidencePercent: Int {
        Int((chord?.confidence ?? 0) * 100)
    }
}
