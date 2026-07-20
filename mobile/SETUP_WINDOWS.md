# GPTone Mobile - Windows Setup

## Prerequisites

### 1. Install Node.js and npm
Download and install from https://nodejs.org/ (LTS recommended)

Verify installation:
```powershell
node --version
npm --version
```

### 2. Create Expo Project

Navigate to the mobile directory and create a new Expo project:

```powershell
cd mobile

# Create new Expo project (interactive)
npx create-expo-app .

# Or with TypeScript template
npx create-expo-app . --template
```

When prompted for project name, you can use the current directory (`.`).

### 3. Install Dependencies

```powershell
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

```powershell
.\check-dependencies.ps1
```

This verifies all required packages are installed.

### 5. Set Up Environment

Create `.env` file in the `mobile/` directory:

```powershell
# Create .env
@"
# Server Configuration
REACT_APP_SERVER_URL=http://localhost:8000
REACT_APP_PEDAL_URL=http://gptone.local

# Development
DEBUG=true
"@ | Set-Content -Path ".env"
```

### 6. Start Development

```powershell
npm start
```

Then:
- **Scan QR code** with **Expo Go** app (iOS/Android)
- Or press `i` for iOS simulator, `a` for Android emulator

## Troubleshooting

### npm install fails
```powershell
npm cache clean --force
rm -recurse -force node_modules, package-lock.json
npm install
```

### Port already in use
```powershell
npm start -- --port 8082
```

### Expo Go won't connect
- Ensure phone and PC are on same WiFi
- Check Windows Firewall isn't blocking port 8081
- Try tunnel mode: press `e` in Expo dev server

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

1. ✅ Run `.\check-dependencies.ps1` to verify setup
2. ✅ Run `npm start` to start dev server
3. ✅ Test on physical device (Expo Go app)
4. ⏳ Edit `src/App.tsx` to customize app

## Important Notes

- `src/App.tsx` is your main app file - start editing there
- The project structure is created by `npx create-expo-app`, not by a bootstrap script
- All dependencies are installed via `npm install` commands above
- Hot reload works automatically - changes to `.tsx` files refresh instantly

## Resources

- **Expo Quick Start:** https://docs.expo.dev/get-started/expo-go/
- **Node.js Download:** https://nodejs.org/
- **Expo Go App:** https://expo.dev/go (iOS/Android)
- **React Native Docs:** https://reactnative.dev/
