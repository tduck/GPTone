# Check dependencies for GPTone mobile (Windows)

Write-Host "🎸 GPTone Mobile Dependencies" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

$required = @(
    'expo',
    '@react-navigation/native',
    '@react-navigation/bottom-tabs',
    'react-native-screens',
    'react-native-safe-area-context',
    'zustand',
    'axios',
    'react-native-paper',
    'react-native-gesture-handler',
    'react-native-reanimated'
)

$pkg = Get-Content package.json -ErrorAction SilentlyContinue | ConvertFrom-Json
$missing = @()

Write-Host "Packages:" -ForegroundColor Yellow
foreach ($p in $required) {
    if ($pkg.dependencies.$p -or $pkg.devDependencies.$p) {
        Write-Host "  ✓ $p" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $p" -ForegroundColor Red
        $missing += $p
    }
}

Write-Host ""
Write-Host "Tools:" -ForegroundColor Yellow

# Expo CLI
try {
    $expo = expo --version 2>$null
    if ($expo) { Write-Host "  ✓ Expo CLI: $expo" -ForegroundColor Green }
    else { throw }
} catch {
    Write-Host "  ❌ Expo CLI" -ForegroundColor Red
    Write-Host "     npm install -g expo-cli" -ForegroundColor Yellow
}

# Node/npm
Write-Host "  ✓ Node: $(node --version)" -ForegroundColor Green
Write-Host "  ✓ npm: $(npm --version)" -ForegroundColor Green

Write-Host ""
if ($missing.Count -gt 0) {
    Write-Host "Missing: $($missing.Count)" -ForegroundColor Red
    Write-Host "Run: npm install" -ForegroundColor Yellow
} else {
    Write-Host "✅ All dependencies installed" -ForegroundColor Green
    Write-Host "Run: npm start" -ForegroundColor Cyan
}
Write-Host ""
