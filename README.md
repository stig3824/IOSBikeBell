# BikeBell 🚲🔔

A SwiftUI iOS application that transforms your iPhone into a smart bike bell using motion detection and sound playback.

## Features

### 🎯 **Core Functionality**
- **Motion Detection**: Automatically detects device movement to trigger bell sounds
- **Sound Playback**: Plays realistic bike bell and cowbell sounds
- **Visual Feedback**: Animated bell interface with color-coded status indicators
- **Settings Management**: Adjustable sensitivity and threshold controls
- **Persistent Settings**: Remembers your preferences between app launches

### 🎨 **User Interface**
- **Dark Mode**: Optimized for low-light cycling conditions
- **Animated Bell**: Visual bell animation when triggered
- **Status Indicators**: Clear ON/OFF status with color coding
- **Tap to Toggle**: Simple tap anywhere to enable/disable motion detection
- **Settings Panel**: Easy access to sensitivity and threshold controls

### 🔧 **Technical Features**
- **Motion Manager**: Core Motion framework integration for device movement detection
- **Sound Manager**: AVFoundation-based audio playback with multiple sound options
- **Custom Bell Generation**: Programmatically generated bell sounds
- **Error Handling**: Comprehensive error handling and user feedback
- **Unit Tests**: Included test suite for core functionality

## Requirements

- **iOS**: 17.0+
- **Xcode**: 15.0+
- **Swift**: 5.0+
- **Device**: iPhone with motion sensors

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/stig3824/IOSBikeBell.git
   ```

2. **Open in Xcode:**
   ```bash
   open BikeBell.xcodeproj
   ```

3. **Build and run** on your device or simulator

## Project Structure

```
BikeBell/
├── BikeBell/
│   ├── BikeBellApp.swift          # Main app entry point
│   ├── ContentView.swift          # Main UI and interaction logic
│   ├── MotionManager.swift        # Device motion detection
│   ├── SoundManager.swift         # Audio playback management
│   ├── BellAnimationView.swift    # Animated bell interface
│   ├── BellImageView.swift        # Bell image display
│   ├── bell.swift                 # Custom bell sound generation
│   ├── Extensions.swift           # Utility extensions
│   ├── Assets.xcassets/           # App icons and colors
│   ├── bellicongreen.png          # Green bell icon
│   ├── belliconorange.png         # Orange bell icon
│   ├── belliconred.png            # Red bell icon
│   ├── bike_bell.m4a              # Bike bell sound file
│   └── cowbell.m4a                # Cowbell sound file
├── BikeBellTests/                 # Unit tests
├── BikeBellUITests/               # UI tests
└── BikeBell.xcodeproj/            # Xcode project file
```

## Usage

### Basic Operation
1. **Launch the app** - The interface shows a bell with ON/OFF status
2. **Tap anywhere** to toggle motion detection on/off
3. **Move your device** when enabled to trigger bell sounds
4. **Access settings** via the menu button (top right)

### Settings
- **Sensitivity**: Adjust how sensitive the motion detection is (default: 100)
- **Threshold**: Set the movement threshold for triggering sounds (default: 11)

### Sound Options
- **Bike Bell**: Traditional bicycle bell sound
- **Cowbell**: Alternative cowbell sound
- **Custom Bell**: Programmatically generated bell tone

## Development

### Key Components

#### MotionManager
Handles device motion detection using Core Motion framework:
- Accelerometer data processing
- Configurable sensitivity and threshold
- Start/stop motion updates
- Error handling

#### SoundManager
Manages audio playback:
- Multiple sound file support
- Volume control
- Audio session management
- Background audio handling

#### ContentView
Main user interface:
- Dark mode optimized design
- Tap gesture handling
- Settings integration
- Status display

### Testing
- **Unit Tests**: Test core functionality in `BikeBellTests/`
- **UI Tests**: Test user interface in `BikeBellUITests/`

## Customization

### Adding New Sounds
1. Add audio files to the `BikeBell/` directory
2. Update `SoundManager.swift` to include new sound options
3. Modify UI to allow sound selection

### Adjusting Motion Sensitivity
- Modify sensitivity and threshold values in `MotionManager.swift`
- Test with different movement patterns
- Consider user preferences for different cycling conditions

### UI Customization
- Modify `BellAnimationView.swift` for different animations
- Update colors and styling in `ContentView.swift`
- Add new status indicators as needed

## Troubleshooting

### Common Issues
- **Motion detection not working**: Check device permissions and motion sensor availability
- **No sound playback**: Verify audio files are included in the bundle
- **Settings not saving**: Ensure `@AppStorage` is properly configured

### Debug Mode
Enable debug logging by modifying the relevant manager classes to include print statements for troubleshooting.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is private and proprietary.

## Author

**Nicholas Spackman**
- Created: April 2025
- Platform: iOS
- Framework: SwiftUI

## Version History

- **v1.0**: Initial release with motion detection and sound playback
- Features: Basic bell functionality, settings, animations

---

**Note**: This app is designed for cycling use. Always follow local laws and safety guidelines when using audio devices while cycling.
