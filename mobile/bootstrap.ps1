# GPTone Mobile - Bootstrap Script (PowerShell)
# Initializes Expo React Native project with all dependencies

$ErrorActionPreference = "Stop"

Write-Host "🎸 GPTone Mobile - Bootstrap Setup" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# Check prerequisites
Write-Host ""
Write-Host "✓ Checking prerequisites..." -ForegroundColor Yellow

$nodeVersion = node --version 2>$null
if (-not $nodeVersion) {
    Write-Host "❌ Node.js not found. Install from https://nodejs.org/" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ Node.js: $nodeVersion" -ForegroundColor Green

$npmVersion = npm --version 2>$null
if (-not $npmVersion) {
    Write-Host "❌ npm not found." -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ npm: $npmVersion" -ForegroundColor Green

# Create project structure
Write-Host ""
Write-Host "✓ Creating project structure..." -ForegroundColor Yellow

$directories = @(
    "src/screens",
    "src/components",
    "src/api",
    "src/store",
    "src/utils",
    "assets/images",
    "assets/fonts",
    "__tests__"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

Write-Host "  ✓ Directory structure created" -ForegroundColor Green

# Install dependencies
Write-Host ""
Write-Host "✓ Installing dependencies..." -ForegroundColor Yellow
npm install

Write-Host ""
Write-Host "✓ Installing Expo CLI globally (if needed)..." -ForegroundColor Yellow
npm install -g expo-cli 2>$null

# Install mobile-specific packages
Write-Host ""
Write-Host "✓ Installing React Navigation..." -ForegroundColor Yellow
npm install @react-navigation/native @react-navigation/bottom-tabs react-native-screens react-native-safe-area-context

Write-Host "✓ Installing state management..." -ForegroundColor Yellow
npm install zustand

Write-Host "✓ Installing HTTP client..." -ForegroundColor Yellow
npm install axios

Write-Host "✓ Installing UI utilities..." -ForegroundColor Yellow
npm install react-native-paper

Write-Host "✓ Installing additional utilities..." -ForegroundColor Yellow
npm install react-native-gesture-handler react-native-reanimated

# Create .env file
Write-Host ""
Write-Host "✓ Setting up environment..." -ForegroundColor Yellow

if (-not (Test-Path ".env")) {
    @"
# Server Configuration
REACT_APP_SERVER_URL=http://localhost:8000
REACT_APP_PEDAL_URL=http://gptone.local

# Development
DEBUG=true
"@ | Set-Content -Path ".env"
    Write-Host "  ✓ Created .env (configure as needed)" -ForegroundColor Green
} else {
    Write-Host "  ✓ .env already exists" -ForegroundColor Green
}

# Create .env.example
@"
# Server Configuration
REACT_APP_SERVER_URL=http://localhost:8000
REACT_APP_PEDAL_URL=http://gptone.local

# Development
DEBUG=true
"@ | Set-Content -Path ".env.example"
Write-Host "  ✓ Created .env.example" -ForegroundColor Green

# Create initial app structure files
Write-Host ""
Write-Host "✓ Creating app structure..." -ForegroundColor Yellow

# app.json
if (-not (Test-Path "app.json")) {
    @"
{
  "expo": {
    "name": "GPTone",
    "slug": "gptone",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/icon.png",
    "userInterfaceStyle": "light",
    "splash": {
      "image": "./assets/splash.png",
      "resizeMode": "contain",
      "backgroundColor": "#ffffff"
    },
    "assetBundlePatterns": [
      "**/*"
    ],
    "ios": {
      "supportsTabletMode": true
    },
    "android": {
      "adaptiveIcon": {
        "foregroundImage": "./assets/adaptive-icon.png",
        "backgroundColor": "#ffffff"
      }
    },
    "web": {
      "favicon": "./assets/favicon.png"
    }
  }
}
"@ | Set-Content -Path "app.json"
}

# tsconfig.json
if (-not (Test-Path "tsconfig.json")) {
    @"
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "resolveJsonModule": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["src"],
  "exclude": ["node_modules"]
}
"@ | Set-Content -Path "tsconfig.json"
}

# src/App.tsx
if (-not (Test-Path "src/App.tsx")) {
    @"
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { MaterialCommunityIcons } from '@expo/vector-icons';

import ToneInputScreen from './screens/ToneInputScreen';
import PresetListScreen from './screens/PresetListScreen';
import ControlScreen from './screens/ControlScreen';

const Tab = createBottomTabNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Tab.Navigator
        screenOptions={({ route }) => ({
          headerShown: true,
          tabBarIcon: ({ color, size }) => {
            let iconName;
            if (route.name === 'ToneInput') {
              iconName = 'microphone';
            } else if (route.name === 'Presets') {
              iconName = 'playlist-music';
            } else if (route.name === 'Control') {
              iconName = 'knob';
            }
            return <MaterialCommunityIcons name={iconName} size={size} color={color} />;
          },
        })}
      >
        <Tab.Screen
          name="ToneInput"
          component={ToneInputScreen}
          options={{ title: 'Generate Tone' }}
        />
        <Tab.Screen
          name="Presets"
          component={PresetListScreen}
          options={{ title: 'Presets' }}
        />
        <Tab.Screen
          name="Control"
          component={ControlScreen}
          options={{ title: 'Control' }}
        />
      </Tab.Navigator>
    </NavigationContainer>
  );
}
"@ | Set-Content -Path "src/App.tsx"
}

# src/screens/ToneInputScreen.tsx
if (-not (Test-Path "src/screens/ToneInputScreen.tsx")) {
    @"
import React, { useState } from 'react';
import { View, Text, TextInput, StyleSheet, ActivityIndicator } from 'react-native';
import { Button } from 'react-native-paper';
import { generateTone } from '../api/server';

export default function ToneInputScreen() {
  const [toneDescription, setToneDescription] = useState('');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState(null);

  const handleGenerateTone = async () => {
    setLoading(true);
    try {
      const preset = await generateTone(toneDescription);
      setResult(preset);
    } catch (error) {
      alert('Error generating tone: ' + error.message);
    }
    setLoading(false);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.label}>Describe the tone you want:</Text>
      <TextInput
        style={styles.input}
        placeholder="e.g., warm, spacey reverb"
        value={toneDescription}
        onChangeText={setToneDescription}
        editable={!loading}
      />

      <Button
        mode="contained"
        onPress={handleGenerateTone}
        disabled={!toneDescription || loading}
      >
        {loading ? 'Generating...' : 'Generate Tone'}
      </Button>

      {loading && <ActivityIndicator style={styles.loader} size="large" />}

      {result && (
        <View style={styles.result}>
          <Text style={styles.resultTitle}>{result.preset_name}</Text>
          <Text style={styles.resultText}>{JSON.stringify(result, null, 2)}</Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#f5f5f5',
  },
  label: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 10,
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    padding: 12,
    marginBottom: 15,
    borderRadius: 8,
    backgroundColor: '#fff',
    fontSize: 16,
  },
  loader: {
    marginVertical: 20,
  },
  result: {
    marginTop: 20,
    padding: 15,
    backgroundColor: '#e8f5e9',
    borderRadius: 8,
  },
  resultTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 10,
  },
  resultText: {
    fontSize: 12,
    color: '#333',
    fontFamily: 'monospace',
  },
});
"@ | Set-Content -Path "src/screens/ToneInputScreen.tsx"
}

# src/screens/PresetListScreen.tsx
if (-not (Test-Path "src/screens/PresetListScreen.tsx")) {
    @"
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function PresetListScreen() {
  return (
    <View style={styles.container}>
      <Text>Preset List (Coming Soon)</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
"@ | Set-Content -Path "src/screens/PresetListScreen.tsx"
}

# src/screens/ControlScreen.tsx
if (-not (Test-Path "src/screens/ControlScreen.tsx")) {
    @"
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function ControlScreen() {
  return (
    <View style={styles.container}>
      <Text>Pedal Control (Coming Soon)</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
"@ | Set-Content -Path "src/screens/ControlScreen.tsx"
}

# src/api/server.ts
if (-not (Test-Path "src/api/server.ts")) {
    @"
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_SERVER_URL || 'http://localhost:8000';

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
});

export const generateTone = async (description: string) => {
  const response = await api.post('/api/generate_tone', {
    description,
  });
  return response.data;
};

export const getPresets = async () => {
  const response = await api.get('/api/presets');
  return response.data;
};

export const savePreset = async (preset: any) => {
  const response = await api.post('/api/presets', preset);
  return response.data;
};
"@ | Set-Content -Path "src/api/server.ts"
}

# src/store/usePresetStore.ts
if (-not (Test-Path "src/store/usePresetStore.ts")) {
    @"
import { create } from 'zustand';

interface Preset {
  id?: string;
  preset_name: string;
  effects: any[];
}

interface PresetStore {
  currentPreset: Preset | null;
  presets: Preset[];
  setCurrentPreset: (preset: Preset) => void;
  addPreset: (preset: Preset) => void;
  removePreset: (id: string) => void;
}

export const usePresetStore = create<PresetStore>((set) => ({
  currentPreset: null,
  presets: [],
  setCurrentPreset: (preset) => set({ currentPreset: preset }),
  addPreset: (preset) =>
    set((state) => ({
      presets: [...state.presets, { ...preset, id: Date.now().toString() }],
    })),
  removePreset: (id) =>
    set((state) => ({
      presets: state.presets.filter((p) => p.id !== id),
    })),
}));
"@ | Set-Content -Path "src/store/usePresetStore.ts"
}

# Initialize git
Write-Host ""
Write-Host "✓ Initializing git repository..." -ForegroundColor Yellow
if (-not (Test-Path ".git")) {
    git init | Out-Null
    git add . 2>$null
    git commit -m "Initial commit: Expo GPTone mobile app scaffold" 2>$null
    Write-Host "  ✓ Git initialized" -ForegroundColor Green
} else {
    Write-Host "  ✓ Git repository already exists" -ForegroundColor Green
}

# Summary
Write-Host ""
Write-Host "✅ Bootstrap Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📱 Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Configure .env with your server URL"
Write-Host "  2. Start development server:"
Write-Host "     npm start"
Write-Host "  3. Test on device:"
Write-Host "     - Scan QR code with Expo Go app (iOS/Android)"
Write-Host "     - Or press 'i' for iOS simulator, 'a' for Android emulator"
Write-Host ""
Write-Host "📚 Installed Packages:" -ForegroundColor Cyan
Write-Host "  - React Navigation (bottom tabs)"
Write-Host "  - Zustand (state management)"
Write-Host "  - Axios (HTTP client)"
Write-Host "  - React Native Paper (UI components)"
Write-Host ""
Write-Host "📁 Project Structure:" -ForegroundColor Cyan
Write-Host "  src/screens/     - Screen components"
Write-Host "  src/components/  - Reusable components"
Write-Host "  src/api/         - API client"
Write-Host "  src/store/       - Zustand store"
Write-Host "  assets/          - Images, fonts"
Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Magenta
