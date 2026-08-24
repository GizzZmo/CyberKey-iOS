//
//  ChromagramAnalyzer.swift
//  CyberKey
//
//  Copyright © 2026 Cybergroup Incorporated
//

import Foundation
import Accelerate

final class ChromagramAnalyzer {
    private let fftSize: Int
    private let sampleRate: Double
    private var fftSetup: FFTSetup?
    private var window: [Float]
    private var realBuffer: [Float]
    private var imagBuffer: [Float]
    private var magnitudes: [Float]
    
    // A4 = 440 Hz reference
    private let noteFrequencies: [Double]
    
    init(fftSize: Int = 4096, sampleRate: Double = 44100) {
        self.fftSize = fftSize
        self.sampleRate = sampleRate
        
        let log2n = vDSP_Length(log2(Float(fftSize)))
        self.fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2))
        
        // Hann window
        self.window = [Float](repeating: 0, count: fftSize)
        vDSP_hann_window(&window, vDSP_Length(fftSize), Int32(vDSP_HANN_NORM))
        
        self.realBuffer = [Float](repeating: 0, count: fftSize / 2)
        self.imagBuffer = [Float](repeating: 0, count: fftSize / 2)
        self.magnitudes = [Float](repeating: 0, count: fftSize / 2)
        
        // Precompute frequencies for pitch classes (MIDI 21–108 approx)
        var freqs: [Double] = []
        for midi in 21...108 {
            let f = 440.0 * pow(2.0, (Double(midi) - 69.0) / 12.0)
            freqs.append(f)
        }
        self.noteFrequencies = freqs
    }
    
    deinit {
        if let setup = fftSetup {
            vDSP_destroy_fftsetup(setup)
        }
    }
    
    /// Analyze a mono float buffer and return 12-bin chromagram (normalized)
    func analyze(buffer: [Float]) -> [Double] {
        guard buffer.count >= fftSize, let setup = fftSetup else {
            return [Double](repeating: 0, count: 12)
        }
        
        // Apply window
        var windowed = [Float](repeating: 0, count: fftSize)
        vDSP_vmul(buffer, 1, window, 1, &windowed, 1, vDSP_Length(fftSize))
        
        // Pack for real FFT
        var splitComplex = DSPSplitComplex(realp: &realBuffer, imagp: &imagBuffer)
        windowed.withUnsafeBufferPointer { ptr in
            ptr.baseAddress!.withMemoryRebound(to: DSPComplex.self, capacity: fftSize / 2) { complexPtr in
                vDSP_ctoz(complexPtr, 2, &splitComplex, 1, vDSP_Length(fftSize / 2))
            }
        }
        
        // Perform FFT
        vDSP_fft_zrip(setup, &splitComplex, 1, vDSP_Length(log2(Float(fftSize))), FFTDirection(kFFTDirection_Forward))
        
        // Magnitudes
        vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(fftSize / 2))
        
        // Convert to power (sqrt optional for energy)
        var chroma = [Double](repeating: 0, count: 12)
        let binHz = sampleRate / Double(fftSize)
        
        for i in 1..<(fftSize / 2) {
            let freq = Double(i) * binHz
            if freq < 60 || freq > 5000 { continue } // useful musical range
            
            let mag = Double(magnitudes[i])
            if mag < 1e-8 { continue }
            
            // Find nearest pitch class
            let midi = 69.0 + 12.0 * log2(freq / 440.0)
            let pc = Int(round(midi).truncatingRemainder(dividingBy: 12))
            let pitchClass = (pc + 12) % 12
            chroma[pitchClass] += mag
        }
        
        // Normalize
        let total = chroma.reduce(0, +)
        if total > 0 {
            chroma = chroma.map { $0 / total }
        }
        
        return chroma
    }
}
