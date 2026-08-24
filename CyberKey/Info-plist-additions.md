# Info.plist Requirements

Add the following keys to your app’s `Info.plist` (or via the Xcode target → Info tab):

```xml
<key>NSMicrophoneUsageDescription</key>
<string>CyberKey needs microphone access to detect musical keys and chords in real time from your instrument or audio source.</string>

<!-- Optional: for background listening -->
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

Also set:

- **Deployment Target**: iOS 26.0
- **Supported Destinations**: iPhone
- **Device Family**: iPhone

Recommended device: **iPhone 17 Pro** / **iPhone 17 Pro Max** for best performance and USB-C external audio support.
