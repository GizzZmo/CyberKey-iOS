# CyberKey-iOS

**Real-time Musical Key (Toneart) & Chord Recognizer**  
Cyberpunk UIX by **Cybergroup Incorporated**  
Optimized for **iPhone 17 Pro** • Built for **iOS 26**

![CyberKey Banner](https://img.shields.io/badge/iOS-26+-black?style=for-the-badge&logo=apple) ![Swift](https://img.shields.io/badge/Swift-6.0-orange?style=for-the-badge&logo=swift) ![License](https://img.shields.io/badge/License-MIT-cyan?style=for-the-badge)

---

## Overview

**CyberKey** is a next-generation iOS app that listens through your iPhone’s microphone (or any connected audio interface / USB-C / Lightning / Bluetooth audio device) and instantly detects:

- **Musical Key / Toneart** (24 keys: 12 major + 12 minor)
- **Live Chords** (major, minor, 7ths, sus, dim, aug, and common extensions)

Perfect for musicians, producers, DJs, guitarists, pianists, and live performers who want instant harmonic feedback in a stunning cyberpunk interface.

> “See the music. Feel the neon.” — Cybergroup Incorporated

## Features

- Real-time key detection using chromagram + Temperley / Krumhansl-Schmuckler profiles
- Live chord recognition from polyphonic audio
- Support for built-in microphone **and** external audio equipment (USB interfaces, Bluetooth mics, audio interfaces via USB-C on iPhone 17 Pro)
- Beautiful **Cyberpunk UIX** with neon glows, scanlines, holographic panels, and reactive spectrum visualizer
- High-performance audio engine using `AVAudioEngine` + Apple Accelerate framework
- Low-latency analysis optimized for A19 Pro chip in iPhone 17 Pro
- Dark neon aesthetic with cyan / magenta / electric purple palette
- Confidence meters and detection history
- Privacy-first: 100% on-device processing, no audio leaves your device

## Requirements

- Xcode 17 or later (iOS 26 SDK)
- iOS 26.0+
- iPhone 17 Pro / Pro Max recommended (works on all iOS 26 compatible devices)
- Microphone permission

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/GizzZmo/CyberKey-iOS.git
cd CyberKey-iOS
```

### 2. Open in Xcode

Create a new **iOS App** project in Xcode named `CyberKey` (SwiftUI + Swift), then replace the generated files with the contents of the `CyberKey/` folder in this repository.

Or simply drag the source files into your project.

### 3. Configure Signing & Capabilities

- Select your Development Team
- Add **Microphone Usage Description** in Info (already provided in source)
- Optional: Background Modes → Audio

### 4. Build & Run

Select iPhone 17 Pro simulator or physical device and hit **Run**.

Grant microphone access when prompted.

## Project Structure

```
CyberKey/
├── CyberKeyApp.swift              # App entry point
├── ContentView.swift              # Main cyberpunk interface
├── Views/
│   ├── NeonDisplayView.swift      # Large key & chord display
│   ├── SpectrumVisualizerView.swift
│   ├── HistoryPanelView.swift
│   └── SettingsView.swift
├── Audio/
│   ├── AudioEngine.swift          # AVAudioEngine + tap
│   ├── ChromagramAnalyzer.swift   # FFT → Chromagram
│   ├── KeyDetector.swift          # Key profile matching
│   └── ChordRecognizer.swift      # Chord template matching
├── Models/
│   ├── MusicalKey.swift
│   ├── Chord.swift
│   └── DetectionResult.swift
├── Theme/
│   └── CyberpunkTheme.swift       # Colors, fonts, effects
└── Info.plist additions
```

## How Detection Works

1. **Audio Capture** – `AVAudioEngine` taps the input node at 44.1 kHz
2. **Windowed FFT** – Using Accelerate `vDSP` for high-speed spectral analysis
3. **Chromagram** – Energy folded into 12 pitch classes (C, C#, … B)
4. **Key Detection** – Correlation against major/minor key profiles (Temperley)
5. **Chord Recognition** – Template matching against common chord vectors with root finding
6. **Smoothing** – Temporal voting + confidence thresholding for stable results

## Cyberpunk Theme (Cybergroup Incorporated)

Designed exclusively by **Cybergroup Incorporated**.

- Deep void backgrounds with subtle grid
- Neon cyan (`#00F0FF`), hot magenta (`#FF00AA`), electric purple
- Glowing text with outer glow shadows
- Animated scanline overlay
- Reactive spectrum bars that pulse with detected energy
- Holographic panels with glassmorphism + neon borders

## Privacy

All audio processing happens **on-device**. No recordings are stored or uploaded unless you explicitly enable export features (future).

## Roadmap

- [ ] MIDI input support (CoreMIDI)
- [ ] Chord progression memory & suggestions
- [ ] Export detected progressions as MIDI / MusicXML
- [ ] Custom chord templates
- [ ] Apple Watch companion
- [ ] Spatial audio visualization (iPhone 17 Pro)

## License

MIT License © 2026 Cybergroup Incorporated & GizzZmo

---

**Built with neon and code in Eidsvoll, Norway.**  
*Cybergroup Incorporated — Seeing the future of sound.*
