#!/bin/bash

# GPTone Mobile - Bootstrap Script
# Initializes Expo React Native project with all dependencies

set -e

echo "🎸 GPTone Mobile - Bootstrap Setup"
echo "===================================="

# Check prerequisites
echo ""
echo "✓ Checking prerequisites..."

if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Install from https://nodejs.org/"
    exit 1
fi
echo "  ✓ Node.js: $(node --version)"

if ! command -v npm &> /dev/null; then
    echo "❌ npm not found."
    exit 1
fi
echo "  ✓ npm: $(npm --version)"

# Create project structure
echo ""
echo "✓ Creating project structure..."

mkdir -p src/{screens,components,api,store,utils}
mkdir -p assets/{images,fonts}
mkdir -p __tests__

echo "  ✓ Directory structure created"

# Install dependencies
echo ""
echo "✓ Installing dependencies..."
npm install

echo ""
echo "✓ Installing Expo CLI globally (if needed)..."
npm install -g expo-cli 2>/dev/null || true

# Install mobile-specific packages
echo ""
echo "✓ Installing React Navigation..."
npm install @react-navigation/native @react-navigation/bottom-tabs react-native-screens react-native-safe-area-context

echo "✓ Installing state management..."
npm install zustand

echo "✓ Installing HTTP client..."
npm install axios

echo "✓ Installing UI utilities..."
npm install react-native-paper

echo "✓ Installing additional utilities..."
npm install react-native-gesture-handler react-native-reanimated

# Create .env file if it doesn't exist
echo ""
echo "✓ Setting up environment..."

if [ ! -f ".env" ]; then
    cat > .env << 'EOF'
# Server Configuration
REACT_APP_SERVER_URL=http://localhost:8000
REACT_APP_PEDAL_URL=http://gptone.local

# Development
DEBUG=true
EOF
    echo "  ✓ Created .env (configure as needed)"
else
    echo "  ✓ .env already exists"
fi

# Create .env.example for version control
cat > .env.example << 'EOF'
# Server Configuration
REACT_APP_SERVER_URL=http://localhost:8000
REACT_APP_PEDAL_URL=http://gptone.local

# Development
DEBUG=true
EOF
echo "  ✓ Created .env.example"

# Create initial app structure files
echo ""
echo "✓ Creating app structure..."

# app.json configuration
if [ ! -f "app.json" ]; then
    cat > app.json << 'EOF'
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
EOF
fi

# Create TypeScript config
if [ ! -f "tsconfig.json" ]; then
    cat > tsconfig.json << 'EOF'
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
EOF
fi

# Create src/App.tsx
if [ ! -f "src/App.tsx" ]; then
    cat > src/App.tsx << 'EOF'
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
EOF
fi

# Create src/screens/ToneInputScreen.tsx
if [ ! -f "src/screens/ToneInputScreen.tsx" ]; then
    cat > src/screens/ToneInputScreen.tsx << 'EOF'
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
EOF
fi

# Create src/screens/PresetListScreen.tsx
if [ ! -f "src/screens/PresetListScreen.tsx" ]; then
    cat > src/screens/PresetListScreen.tsx << 'EOF'
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
EOF
fi

# Create src/screens/ControlScreen.tsx
if [ ! -f "src/screens/ControlScreen.tsx" ]; then
    cat > src/screens/ControlScreen.tsx << 'EOF'
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
EOF
fi

# Create src/api/server.ts
if [ ! -f "src/api/server.ts" ]; then
    cat > src/api/server.ts << 'EOF'
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
EOF
fi

# Create src/store/usePresetStore.ts
if [ ! -f "src/store/usePresetStore.ts" ]; then
    cat > src/store/usePresetStore.ts << 'EOF'
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
EOF
fi

# Initialize git (if not already a repo)
echo ""
echo "✓ Initializing git repository..."
if [ ! -d ".git" ]; then
    git init
    git add .
    git commit -m "Initial commit: Expo GPTone mobile app scaffold" 2>/dev/null || true
    echo "  ✓ Git initialized"
else
    echo "  ✓ Git repository already exists"
fi

# Summary
echo ""
echo "✅ Bootstrap Complete!"
echo ""
echo "📱 Next Steps:"
echo "  1. Configure .env with your server URL"
echo "  2. Start development server:"
echo "     npm start"
echo "  3. Test on device:"
echo "     - Scan QR code with Expo Go app (iOS/Android)"
echo "     - Or press 'i' for iOS simulator, 'a' for Android emulator"
echo ""
echo "📚 Installed Packages:"
echo "  - React Navigation (bottom tabs)"
echo "  - Zustand (state management)"
echo "  - Axios (HTTP client)"
echo "  - React Native Paper (UI components)"
echo ""
echo "📁 Project Structure:"
echo "  src/screens/     - Screen components"
echo "  src/components/  - Reusable components"
echo "  src/api/         - API client"
echo "  src/store/       - Zustand store"
echo "  assets/          - Images, fonts"
echo ""
echo "Happy coding! 🚀"
