#!/bin/bash

echo "🚀 Lancement de la démo mobile Flutter Bluetooth Scanner"
echo "📱 Simulation d'interface smartphone"
echo ""

pkill -f "flutter.*web-server" 2>/dev/null || true

sleep 2

echo "🔄 Compilation et lancement..."
flutter run -t lib/main_demo.dart -d web-server --web-port 8082 &

echo "⏳ Attente du serveur web..."
sleep 15

echo "🌐 Ouverture automatique du navigateur..."
if command -v xdg-open > /dev/null; then
    xdg-open http://localhost:8082
elif command -v open > /dev/null; then
    open http://localhost:8082
else
    echo "📋 Ouvrez manuellement: http://localhost:8082"
fi

echo ""
echo "✅ Démo prête !"
echo "🎯 URL: http://localhost:8082"
echo "📱 Interface mobile simulée dans le navigateur"
echo ""
echo "🛑 Pour arrêter: Ctrl+C"
