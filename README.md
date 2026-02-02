# Nature Onboarding Alarm App 🌿⏰

A Flutter-based travel alarm application featuring video onboarding, background music, location access, and smart alarm scheduling. The app is designed with a modern UI and focuses on smooth user experience and clean architecture.

---

## ✨ Features

- 🎬 Video-based onboarding (different video per screen)
- 🎵 Background music during onboarding
- 📍 Location permission & current location detection
- ⏰ Add, enable, disable, and delete alarms
- 🔔 Local notifications for alarms
- 🎨 Modern UI with gradients and rounded components
- 🚀 Optimized for performance and stability

---

## 🧰 Tools & Packages Used

### 🛠️ Development Tools
- Flutter SDK
- Dart
- Android Studio (Emulator / Build tools)
- VS Code
- Git & GitHub

### 📦 Flutter Packages
- `video_player` – Video onboarding screens
- `audioplayers` – Background music playback
- `geolocator` – Current device location
- `permission_handler` – Runtime permission handling
- `flutter_local_notifications` – Local alarm notifications
- `timezone` – Accurate scheduling with time zones
- `intl` – Date/time formatting
- `provider` – State management
- `shared_preferences` – Lightweight local storage (optional)

---

## 📸 Screenshots

> Here is the ultimate Output......

### Onboarding
![Onboarding 1](screenshots/page1.png)
![Onboarding 2](screenshots/page2.png)
![Onboarding 3](screenshots/page3.png)

### Location
![Location](screenshots/page4.png)


### Alarm
![Alarms](screenshots/page5.png)
![Alarms](screenshots/page6.png)
---

## 📱 App Flow

1. Video onboarding with background music
2. Location permission screen
3. Home alarm screen
4. Add alarm using time picker
5. Receive scheduled notification




## ⚠️ Notes

1. Exact alarms may not trigger on some Android emulators due to system limitations.
2. The app works correctly on real Android devices.
3. Background music and video playback are optimized to prevent emulator crashes.