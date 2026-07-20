#!/bin/bash

# Check dependencies for GPTone mobile (macOS/Linux)

echo "🎸 GPTone Mobile Dependencies"
echo "=============================="
echo ""

required=("expo" "@react-navigation/native" "@react-navigation/bottom-tabs" \
    "react-native-screens" "react-native-safe-area-context" "zustand" \
    "axios" "react-native-paper" "react-native-gesture-handler" \
    "react-native-reanimated")

missing=()

echo "Packages:"
for pkg in "${required[@]}"; do
    if grep -q "\"$pkg\"" package.json 2>/dev/null; then
        echo "  ✓ $pkg"
    else
        echo "  ❌ $pkg"
        missing+=("$pkg")
    fi
done

echo ""
echo "Tools:"

# Expo CLI
if command -v expo &> /dev/null; then
    echo "  ✓ Expo CLI: $(expo --version 2>/dev/null)"
else
    echo "  ❌ Expo CLI"
    echo "     npm install -g expo-cli"
fi

# Node/npm
echo "  ✓ Node: $(node --version)"
echo "  ✓ npm: $(npm --version)"

echo ""
if [ ${#missing[@]} -gt 0 ]; then
    echo "Missing: ${#missing[@]}"
    echo "Run: npm install"
else
    echo "✅ All dependencies installed"
    echo "Run: npm start"
fi
echo ""
