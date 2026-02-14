# AndPlayer - Accessible Music Player


## 🎵 Overview

AndPlayer is an accessible, user-friendly music player application built with Flutter, designed for seamless offline audio playback. With an intuitive interface optimized for ease of use, AndPlayer provides a smooth music listening experience with essential playback features and accessibility-first design.

---


## 🎥 Demo Video

[![AndPlayer Demo](https://img.youtube.com/vi/vZSAgY-68G0/maxresdefault.jpg)](https://youtube.com/shorts/vZSAgY-68G0)

**[🎬 Watch on YouTube Shorts](https://youtube.com/shorts/vZSAgY-68G0)**

See AndPlayer's music playback, playlist management, and accessible interface in action!


---


## ✨ Key Features

- 🎧 **Offline Audio Playback** - Play music stored locally on your device
- 📁 **Automatic File Detection** - Scans and organizes audio files from device storage
- 🎼 **Playlist Management** - Create, edit, and manage custom playlists
- 🔀 **Shuffle & Repeat Modes** - Randomize playback or repeat your favorites
- 📋 **Audio Queue Management** - View and manage upcoming tracks
- 🎨 **Clean, Intuitive Interface** - Accessible design with easy navigation
- 🔍 **Search & Filter** - Quickly find songs, artists, or albums
- 💾 **Persistent Playback State** - Resumes where you left off
- 🌓 **Theme Support** - Light and dark mode options
- ♿ **Accessibility Optimized** - Large touch targets, screen reader compatible

---

## 🛠️ Tech Stack

### Frontend
- **Framework:** Flutter (Dart)
- **Audio Engine:** just_audio / audioplayers package
- **State Management:** Provider / BLoC
- **Local Storage:** SQLite for metadata and playlists
- **File System:** path_provider for accessing device storage

### Features
- **Audio Processing:** Metadata extraction (ID3 tags)
- **UI/UX:** Material Design, Custom animations
- **Performance:** Background playback, efficient memory management

---



## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│          Flutter UI Layer           │
│   (Screens, Widgets, Animations)    │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│      Business Logic Layer           │
│   (State Management, Controllers)   │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│       Data & Services Layer         │
│  • Audio Player Service             │
│  • File System Scanner              │
│  • SQLite Database                  │
│  • Metadata Parser                  │
└─────────────���───────────────────────┘
```

---

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK 3.0+
- Android Studio / VS Code
- Android device or emulator
- Git

### Setup Instructions

```bash
# Clone repository
git clone https://github.com/smokhood/andplayer.git
cd andplayer

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Supported Platforms
- ✅ Android 5.0+ (API level 21+)
- ✅ iOS 11.0+ (with minor adjustments)
- ⏳ Web (future support)

---

## 🎮 How to Use

### Getting Started
1. **Launch AndPlayer** on your device
2. **Grant Permissions** - Allow storage access to scan audio files
3. **Wait for Scan** - App automatically detects and organizes music
4. **Start Playing** - Tap any song to begin playback

### Main Features

#### 🎵 Music Library
- Browse all songs, albums, and artists
- Sort by name, date added, or duration
- Search functionality for quick access

#### 📋 Playlists
- Create custom playlists
- Add/remove songs easily
- Reorder tracks with drag-and-drop

#### 🎛️ Playback Controls
- Play, pause, skip forward/backward
- Seek to any position in the track
- Shuffle and repeat modes
- Volume control

#### ⚙️ Settings
- Adjust theme (light/dark)
- Configure audio quality
- Manage storage and cache
- Accessibility options


---

## 🔧 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Audio playback
  just_audio: ^0.9.34
  audio_service: ^0.18.10
  
  # State management
  provider: ^6.0.5
  
  # Database
  sqflite: ^2.2.8
  path_provider: ^2.0.15
  
  # File system
  permission_handler: ^10.4.3
  file_picker: ^5.3.2
  
  # Metadata
  flutter_audio_query: ^1.0.0
  audiotagger: ^2.2.1
  
  # UI
  cached_network_image: ^3.2.3
  flutter_slidable: ^3.0.0
```

---

## 🎨 Design Philosophy

AndPlayer is built with **accessibility and simplicity** at its core:

- ♿ **Accessibility First** - Large buttons, clear labels, screen reader support
- 🎯 **User-Centric** - Intuitive navigation, minimal learning curve
- ⚡ **Performance** - Efficient scanning, smooth animations, low battery usage
- 🎨 **Clean Design** - Material Design principles, consistent UI
- 🔒 **Privacy** - No internet required, no data collection, offline-only


---

## 🐛 Known Issues

- Large libraries (>5000 songs) may take time to scan on first launch
- Album art extraction works best with properly tagged files
- Background playback requires notification permissions

---

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

---


## 👨‍💻 Author

**Ahtisham**  
- GitHub: [@smokhood](https://github.com/smokhood)
- Email: ahtishamravian206@gmail.com

---

## 🙏 Acknowledgments

- Flutter community for amazing packages
- Material Design for UI guidelines
- [just_audio](https://pub.dev/packages/just_audio) for audio playback engine
- Open-source contributors

---

- Email: ahtishamravian206@gmail.com

---

## 🙏 Acknowledgments

- Flutter community for amazing packages
- Material Design for UI guidelines
- [just_audio](https://pub.dev/packages/just_audio) for audio playback engine
- Open-source contributors

---

## 📥 Download & Install

### Latest Release: v1.0.0

<a href="https://github.com/smokhood/andplayer/releases/latest">
  <img src="https://img.shields.io/badge/Download-APK-brightgreen?style=for-the-badge&logo=android" alt="Download APK"/>
</a>

[![GitHub release](https://img.shields.io/github/v/release/smokhood/andplayer)](https://github.com/smokhood/andplayer/releases)
[![Downloads](https://img.shields.io/github/downloads/smokhood/andplayer/total)](https://github.com/smokhood/andplayer/releases)

**[📱 Download AndPlayer v1.0.0 APK](https://github.com/smokhood/andplayer/releases/download/v1.0.0/andplayer-v1.0.0.apk)**

Or visit the **[Releases page](https://github.com/smokhood/andplayer/releases)** for all versions.

---

### 📱 Installation Instructions

1. **Download** the APK using the button above
2. **Enable "Install from Unknown Sources"** on your device:
   - Go to **Settings** → **Security** → Enable **"Unknown Sources"**
   - Or **Settings** → **Apps** → **Special Access** → **Install Unknown Apps**
3. **Open** the downloaded APK file from your notifications or Downloads folder
4. **Tap "Install"** and wait for installation to complete
5. **Open AndPlayer** and grant storage permission to access your music
6. **Enjoy!** 🎵

---

### ⚙️ System Requirements

- 📱 **Android:** 5.0 (Lollipop) or higher
- 💾 **Storage:** ~30MB free space
- 🔐 **Permissions:** Storage access (to scan and play music files)

---

### 🔒 Privacy & Security

- ✅ **No internet required** - Fully offline app
- ✅ **No data collection** - Your music stays on your device
- ✅ **No ads or trackers** - Clean, private experience
- ✅ **Open source** - Code is transparent and verifiable

Storage permission is only used to access your local music files.

---

**⭐ If you enjoy AndPlayer, please give it a star!**

---

*Making music accessible, one play at a time* 🎵


---

**⭐ If you enjoy AndPlayer, please give it a star!**

---

*Making music accessible, one play at a time* 🎵
