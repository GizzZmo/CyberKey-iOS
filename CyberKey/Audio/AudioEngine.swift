//
//  AudioEngine.swift
//  CyberKey
//
//  Copyright © 2026 Cybergroup Incorporated
//

import Foundation
import AVFoundation
import Combine

@MainActor
final class AudioEngine: ObservableObject {
    @Published var isRunning = false
    @Published var currentKey: MusicalKey = MusicalKey(root: 0, mode: .major, confidence: 0)
    @Published var currentChord: Chord? = nil
    @Published var chroma: [Double] = [Double](repeating: 0, count: 12)
    @Published var inputLevel: Float = 0
    @Published var history: [DetectionResult] = []
    @Published var errorMessage: String?
    
    private let engine = AVAudioEngine()
    private let analyzer = ChromagramAnalyzer(fftSize: 4096, sampleRate: 44100)
    private var isConfigured = false
    
    // Smoothing / voting
    private var keyVotes: [String: Int] = [:]
    private var chordVotes: [String: Int] = [:]
    private let voteWindow = 8
    private var frameCount = 0
    
    func requestPermissionAndStart() async {
        do {
            let granted = await AVAudioApplication.requestRecordPermission()
            guard granted else {
                errorMessage = "Microphone access denied. Enable in Settings."
                return
            }
            try configureSession()
            try start()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func configureSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(
            .playAndRecord,
            mode: .measurement,
            options: [
                .defaultToSpeaker,
                .allowBluetooth,
                .allowBluetoothA2DP,
                .allowAirPlay,
                .mixWithOthers
            ]
        )
        try session.setPreferredSampleRate(44100)
        try session.setPreferredIOBufferDuration(0.01)
        try session.setActive(true, options: .notifyOthersOnDeactivation)
        
        // Prefer external input if available (USB-C audio interfaces on iPhone 17 Pro)
        if let inputs = session.availableInputs {
            // Prefer non-built-in if present
            if let external = inputs.first(where: { $0.portType != .builtInMic }) {
                try session.setPreferredInput(external)
            }
        }
    }
    
    func start() throws {
        guard !isRunning else { return }
        
        let input = engine.inputNode
        let format = input.inputFormat(forBus: 0)
        
        // Install tap
        input.installTap(onBus: 0, bufferSize: 4096, format: format) { [weak self] buffer, _ in
            guard let self = self else { return }
            self.process(buffer: buffer)
        }
        
        engine.prepare()
        try engine.start()
        isRunning = true
        errorMessage = nil
    }
    
    func stop() {
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        isRunning = false
    }
    
    private nonisolated func process(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameLength = Int(buffer.frameLength)
        
        var samples = [Float](repeating: 0, count: frameLength)
        for i in 0..<frameLength {
            samples[i] = channelData[i]
        }
        
        // Level meter
        var rms: Float = 0
        vDSP_rmsqv(samples, 1, &rms, vDSP_Length(frameLength))
        
        let chroma = analyzer.analyze(buffer: samples)
        let key = MusicalKey.detect(from: chroma)
        let chord = Chord.recognize(from: chroma)
        
        Task { @MainActor in
            self.inputLevel = min(1.0, rms * 8)
            self.chroma = chroma
            self.updateDetections(key: key, chord: chord, chroma: chroma)
        }
    }
    
    private func updateDetections(key: MusicalKey, chord: Chord?, chroma: [Double]) {
        frameCount += 1
        
        // Key voting
        let keyId = "\(key.root)-\(key.mode.rawValue)"
        keyVotes[keyId, default: 0] += 1
        
        // Chord voting
        if let c = chord {
            let chordId = "\(c.root)-\(c.quality)"
            chordVotes[chordId, default: 0] += 1
        }
        
        // Every few frames, pick winners
        if frameCount % 4 == 0 {
            if let bestKeyId = keyVotes.max(by: { $0.value < $1.value })?.key {
                let parts = bestKeyId.split(separator: "-")
                if let root = Int(parts[0]), let mode = KeyMode(rawValue: String(parts[1])) {
                    let conf = Double(keyVotes[bestKeyId] ?? 0) / Double(voteWindow)
                    currentKey = MusicalKey(root: root, mode: mode, confidence: min(1, conf + key.confidence * 0.3))
                }
            }
            
            if let bestChordId = chordVotes.max(by: { $0.value < $1.value })?.key {
                let parts = bestChordId.split(separator: "-")
                if let root = Int(parts[0]) {
                    let quality = String(parts[1])
                    let conf = Double(chordVotes[bestChordId] ?? 0) / Double(voteWindow)
                    currentChord = Chord(root: root, quality: quality, confidence: min(1, conf))
                }
            } else {
                currentChord = nil
            }
            
            // Trim vote maps
            if keyVotes.count > 20 { keyVotes.removeAll() }
            if chordVotes.count > 20 { chordVotes.removeAll() }
            
            // Add to history occasionally
            if frameCount % 20 == 0 && currentKey.confidence > 0.4 {
                let result = DetectionResult(
                    timestamp: Date(),
                    key: currentKey,
                    chord: currentChord,
                    chroma: chroma
                )
                history.insert(result, at: 0)
                if history.count > 30 {
                    history.removeLast()
                }
            }
        }
    }
}
