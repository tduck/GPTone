# GPTone Mobile - Setup Guide

Expo React Native app for GPTone guitar effects pedal.

## Prerequisites

Install Node.js + npm from https://nodejs.org/ (LTS). This project uses version 24.18.

**Verify:**
```bash
node --version
npm --version
```

## Step 1: Create Expo Project

```bash
cd mobile
npx create-expo-app .
# or with TypeScript
npx create-expo-app . --template
```

## Step 2: Install Dependencies

```bash
# Expo CLI globally
npm install -g expo-cli

# Project dependencies
npm install

# React Navigation
npm install @react-navigation/native @react-navigation/bottom-tabs
npm install react-native-screens react-native-safe-area-context

# State + HTTP + UI
npm install zustand axios react-native-paper

# Gestures + animations
npm install react-native-gesture-handler react-native-reanimated
```

## Step 3: Verify Installation

**Windows (PowerShell):**
```powershell
.\check-dependencies.ps1
```

**macOS/Linux (Bash):**
```bash
chmod +x ./check-dependencies.sh
./check-dependencies.sh
```

## Step 4: Configure Environment

Create `.env` in `mobile/` directory:

```bash
# .env
REACT_APP_SERVER_URL=http://localhost:8000
REACT_APP_PEDAL_URL=http://gptone.local
DEBUG=true
```

## Step 5: Start Development

```bash
npm start
```

Then:
- Scan QR code with **Expo Go** app (iOS/Android)
- Or press `i` (iOS simulator), `a` (Android emulator)

## Troubleshooting

**npm install fails:**
```bash
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

**Port 8081 in use:**
```bash
npm start -- --port 8082
```

**Expo Go won't connect:**
- Phone + PC on same WiFi
- Firewall not blocking 8081
- Try tunnel: press `e` in dev server

**macOS Simulator:**
```bash
# Press 'i' automatically opens iOS simulator
open -a Simulator  # manual start
```

**Linux Android SDK:**
```bash
# Ubuntu
sudo apt install android-sdk

# Or download Android Studio
# https://developer.android.com/studio
```

**Linux Firewall:**
```bash
# UFW
sudo ufw allow 8081/tcp

# Firewalld
sudo firewall-cmd --permanent --add-port=8081/tcp
sudo firewall-cmd --reload
```

## Project Structure

```
mobile/
├── src/
│   ├── App.tsx           # Main app (start editing here)
│   └── ...
├── assets/               # Images, fonts
├── node_modules/         # Packages
├── app.json             # Expo config
├── package.json
├── tsconfig.json
├── .env                 # Environment (create)
├── .env.example         # Template
├── check-dependencies.ps1
└── check-dependencies.sh
```

## Next Steps

1. Run dependency checker
2. Run `npm start`
3. Test on device (Expo Go)
4. Edit `src/App.tsx`

## Key Notes

- Project created by `npx create-expo-app`, not bootstrap script
- Hot reload = instant refresh on file save
- Start with `src/App.tsx`
- `.env` file needed before `npm start`

## Resources

- Expo Docs: https://docs.expo.dev/get-started/expo-go/
- React Native: https://reactnative.dev/
- Expo Go: https://expo.dev/go
