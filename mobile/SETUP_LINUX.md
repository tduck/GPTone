# GPTone Mobile - Linux & macOS Setup

## Prerequisites

### 1. Install Node.js and npm

**macOS (with Homebrew):**
```bash
brew install node
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install nodejs npm
```

**Linux (Fedora/RedHat):**
```bash
sudo dnf install nodejs npm
```

Verify installation:
```bash
node --version
npm --version
```

### 2. Create Expo Project

Navigate to the mobile directory and create a new Expo project:

```bash
cd mobile

# Create new Expo project (interactive)
npx create-expo-app .

# Or with TypeScript template
npx create-expo-app . --template
```

When prompted for project name, you can use the current directory (`.`).

### 3. Install Dependencies

```bash
# Install Expo CLI globally
npm install -g expo-cli

# Install project dependencies
npm install

# Install React Navigation
npm install @react-navigation/native @react-navigation/bottom-tabs
npm install react-native-screens react-native-safe-area-context

# Install state management
npm install zustand

# Install HTTP client
npm install axios

# Install UI library
npm install react-native-paper

# Install gesture handling
npm install react-native-gesture-handler react-native-reanimated
```

### 4. Verify Installation

Run the dependency checker:

```bash
chmod +x ./check-dependencies.sh
./check-dependencies.sh
```

This verifies all required packages are installed.

### 5. Set Up Environment

Create `.env` file in the `mobile/` directory:

```bash
# Create .env
cat > .env << 'EOF'
# Server Configuration
REACT_APP_SERVER_URL=http://localhost:8000
REACT_APP_PEDAL_URL=http://gptone.local

# Development
DEBUG=true
EOF
```

### 6. Start Development

```bash
npm start
```

Then:
- **Scan QR code** with **Expo Go** app (iOS/Android)
- Or press `i` for iOS simulator, `a` for Android emulator

## Troubleshooting

### npm install fails
```bash
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

### Port already in use
```bash
npm start -- --port 8082
```

### Expo Go won't connect
- Ensure phone and PC are on same WiFi
- Check firewall isn't blocking port 8081
- Try tunnel mode: press `e` in Expo dev server

### Permission denied when running scripts
```bash
chmod +x ./check-dependencies.sh
./check-dependencies.sh
```

## Project Structure After Setup

```
mobile/
├── src/                      # Your app code
│   ├── App.tsx              # Main component (edit this first)
│   └── ...
├── assets/                  # Images, fonts
├── node_modules/            # Installed packages
├── app.json                 # Expo config
├── package.json
├── tsconfig.json           # TypeScript config
├── .env                    # Environment variables (create this)
└── .env.example            # Template
```

## Next Steps

1. ✅ Run `./check-dependencies.sh` to verify setup
2. ✅ Run `npm start` to start dev server
3. ✅ Test on physical device (Expo Go app)
4. ⏳ Edit `src/App.tsx` to customize app

## Important Notes

- `src/App.tsx` is your main app file - start editing there
- The project structure is created by `npx create-expo-app`, not by a bootstrap script
- All dependencies are installed via `npm install` commands above
- Hot reload works automatically - changes to `.tsx` files refresh instantly

## macOS-Specific Notes

### Using Xcode Simulator
```bash
# After running npm start, press 'i'
# This automatically opens iOS simulator

# If simulator doesn't start automatically
open -a Simulator
```

### M1/M2 Mac (ARM)
Node.js should work out of the box with Homebrew. If you have issues:

```bash
# Reinstall with ARM native build
brew uninstall node
brew install node@18  # or @20
```

## Linux-Specific Notes

### Android Emulator Setup
To use Android emulator on Linux, you'll need Android SDK:

```bash
# Ubuntu - install android-sdk
sudo apt install android-sdk

# Or download Android Studio
# https://developer.android.com/studio
```

### Firewall Configuration
If Expo can't connect:

```bash
# UFW (Ubuntu)
sudo ufw allow 8081/tcp

# Firewalld (Fedora)
sudo firewall-cmd --permanent --add-port=8081/tcp
sudo firewall-cmd --reload
```

## Resources

- **Expo Quick Start:** https://docs.expo.dev/get-started/expo-go/
- **Node.js Download:** https://nodejs.org/
- **Expo Go App:** https://expo.dev/go (iOS/Android)
- **React Native Docs:** https://reactnative.dev/
