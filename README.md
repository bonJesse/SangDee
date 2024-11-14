# SangDee (แสงดี) Light Control System

## Overview
SangDee is a web-based light control system that provides an intuitive interface for adjusting lighting settings. The name "แสงดี" (SangDee) means "good light" in Thai.

## Features
- Quick color presets with 8 predefined options
- Advanced color control with RGB sliders and color wheel
- Real-time brightness adjustment
- Camera preview for testing lighting effects
- Fullscreen mode support
- Mobile-optimized interface
- Bilingual support (English/Thai)

## Platforms
- Web (Chrome, Safari)
- iOS (Chrome, Safari)
- Android (Chrome)

## Version
Current version: 1.0.3

## Usage

### Basic Controls
1. Quick Color Selection
   - Tap the color cards to instantly apply preset colors
   - Swipe up/down to show/hide color presets

2. Brightness Control
   - Use the slider to adjust brightness level
   - Values range from 0-100%

### Advanced Settings
Access advanced settings through the menu button:

1. Color Settings
   - Color wheel for precise color selection
   - RGB sliders for fine-tuning
   - Real-time color preview

2. Camera Preview
   - Toggle camera to test lighting effects
   - Supports both front and back cameras
   - Requires camera permission

3. Fullscreen Mode
   - Toggle fullscreen for better visibility
   - Available on supported devices

## Technical Requirements
- Modern web browser with JavaScript enabled
- Camera permissions (optional)
- Touch screen support recommended

## Browser Compatibility
- Chrome (iOS/Android): Full support
- Safari (iOS): Full support
- Other mobile browsers: Basic support

## Installation
No installation required. Access directly through web browser.

## Development
Built with:
- HTML5
- CSS3
- JavaScript (ES6+)
- Mobile-first responsive design

## Notes
- Camera access requires HTTPS or localhost
- Some features may require device permissions
- Performance may vary based on device capabilities

## License
MIT License

## iOS App

### Features
- 📱 Native iOS UI with modern design
- 📸 Front camera preview integration
- 🎨 Quick color presets with horizontal scrolling
- 🔆 Real-time brightness control
- 👆 Gesture-based interface control
- ⚙️ Side menu for detailed settings

### Technical Details
- **Framework**: UIKit
- **Dependencies**:
  - SnapKit for layout
  - RxSwift for reactive programming
  - AVFoundation for camera handling

### Key Components
1. **Preview Area**
   - Rounded corners design
   - Camera preview integration
   - Real-time color preview
   - Double-tap gesture support

2. **Color Control**
   - Horizontal scrolling color cards
   - Preset color selection
   - Custom color support
   - Smooth color transitions

3. **Brightness Control**
   - Quick access brightness slider
   - Real-time adjustment
   - Smooth animation
   - 0-100% range

4. **Gesture Controls**
   - Double-tap to hide/show controls
   - Smooth animation transitions
   - Intuitive user interaction

5. **Side Menu**
   - Modal presentation
   - Detailed color settings
   - Advanced brightness control
   - iOS 16+ sheet presentation style

### Requirements
- iOS 14.0+
- Xcode 13.0+
- Swift 5.0+
- Camera permission

### Installation
1. Clone the repository
2. Install dependencies via CocoaPods
3. Open `SangDee.xcworkspace`
4. Build and run on device