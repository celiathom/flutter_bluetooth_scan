# Flutter Bluetooth Scanner

Une application Flutter qui permet de scanner et lister les appareils Bluetooth à proximité.

## 🚀 Fonctionnalités

- **Scan Bluetooth** : Recherche automatique des appareils Bluetooth environnants
- **Interface intuitive** : Liste claire des appareils détectés avec informations détaillées
- **Gestion d'état avec BLoC** : Architecture propre utilisant le pattern BLoC
- **Indicateur de signal** : Visualisation de la force du signal (RSSI) avec code couleur
- **Permissions automatiques** : Gestion intelligente des permissions Bluetooth

## 🏗️ Architecture

L'application suit le pattern **BLoC (Business Logic Component)** pour une séparation claire des responsabilités :

```
lib/
├── bloc/                    # Gestion d'état BLoC
│   ├── bluetooth_scan_bloc.dart
│   ├── bluetooth_scan_event.dart
│   ├── bluetooth_scan_state.dart
│   └── bloc.dart
├── models/                  # Modèles de données
│   └── bluetooth_device_model.dart
├── screens/                 # Écrans de l'application
│   └── bluetooth_scan_screen.dart
├── widgets/                 # Composants réutilisables
│   └── bluetooth_device_card.dart
└── main.dart               # Point d'entrée
```

## 📚 Technologies utilisées

- **Flutter** : Framework de développement mobile
- **flutter_blue_plus** : Gestion Bluetooth Low Energy
- **flutter_bloc** : Gestion d'état avec pattern BLoC
- **equatable** : Comparaison d'objets simplifiée
- **permission_handler** : Gestion des permissions

## 🔧 Installation

1. **Cloner le repository**
   ```bash
   git clone <votre-repo>
   cd flutter_bluetooth_scan
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Lancer l'application**
   ```bash
   flutter run
   ```

## 📱 Permissions

L'application nécessite les permissions suivantes :

### Android
- `BLUETOOTH` : Accès Bluetooth de base
- `BLUETOOTH_ADMIN` : Administration Bluetooth
- `ACCESS_FINE_LOCATION` : Localisation précise (requise pour BLE)
- `BLUETOOTH_SCAN` : Scan Bluetooth (Android 12+)
- `BLUETOOTH_CONNECT` : Connexion Bluetooth (Android 12+)

### iOS
- `NSBluetoothAlwaysUsageDescription` : Utilisation du Bluetooth

## 🎯 Utilisation

1. **Lancer l'application**
2. **Activer le Bluetooth** si nécessaire
3. **Appuyer sur "Démarrer le scan"** pour rechercher les appareils
4. **Visualiser la liste** des appareils détectés avec leur signal
5. **Arrêter le scan** quand souhaité

## 📊 Fonctionnalités détaillées

### États de l'application
- **Initial** : État de démarrage
- **Loading** : Initialisation du scan
- **Scanning** : Scan en cours avec mise à jour en temps réel
- **Stopped** : Scan arrêté avec liste des appareils
- **Error** : Gestion des erreurs avec messages explicites
- **Unavailable** : Bluetooth non disponible

### Indicateurs visuels
- 🟢 **Signal fort** (> -50 dBm) : Vert
- 🟠 **Signal moyen** (-50 à -70 dBm) : Orange  
- 🔴 **Signal faible** (< -70 dBm) : Rouge

## 🔍 Architecture BLoC

### Events (Événements)
- `StartScanEvent` : Démarrer le scan
- `StopScanEvent` : Arrêter le scan
- `ClearDevicesEvent` : Vider la liste
- `CheckBluetoothStateEvent` : Vérifier l'état Bluetooth

### States (États)
- `BluetoothScanInitial` : État initial
- `BluetoothScanLoading` : Chargement
- `BluetoothScanScanning` : Scan en cours
- `BluetoothScanStopped` : Scan arrêté
- `BluetoothScanError` : Erreur
- `BluetoothUnavailable` : Bluetooth indisponible

## 🛠️ Développement

### Structure du code
- **Clean Architecture** : Séparation des couches
- **SOLID Principles** : Respect des principes SOLID
- **BLoC Pattern** : Gestion d'état réactive
- **Reactive Programming** : Streams et événements

### Bonnes pratiques implémentées
- ✅ Gestion d'état centralisée
- ✅ Séparation des responsabilités
- ✅ Gestion d'erreurs robuste
- ✅ Interface utilisateur réactive
- ✅ Code documenté et maintenable

## 🚧 Améliorations futures

- [ ] Persistance des appareils favoris
- [ ] Connexion aux appareils détectés
- [ ] Filtres de recherche avancés
- [ ] Export des données en CSV
- [ ] Mode sombre
- [ ] Tests unitaires et d'intégration

## 📄 Licence

Ce projet est développé dans le cadre d'un test technique pour Epitech.

---

**Développé avec ❤️ et Flutter**
