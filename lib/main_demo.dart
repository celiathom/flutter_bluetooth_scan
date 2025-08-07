import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/demo_bluetooth_scan_bloc.dart';
import 'screens/mobile_bluetooth_scan_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bluetooth Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'SF Pro Display', // Police iOS-like
      ),
      home: const MobileFrameWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Wrapper qui simule un écran de téléphone moderne
class MobileFrameWrapper extends StatelessWidget {
  const MobileFrameWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a), // Fond très sombre
      body: Center(
        child: Container(
          width: 390, // iPhone 14 Pro width
          height: 844, // iPhone 14 Pro height
          decoration: BoxDecoration(
            // Cadre du téléphone avec effet métal
            color: const Color(0xFF1c1c1e),
            borderRadius: BorderRadius.circular(48),
            border: Border.all(
              color: const Color(0xFF3a3a3c),
              width: 2,
            ),
            boxShadow: [
              // Ombre principale
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 40,
                spreadRadius: 0,
                offset: const Offset(0, 20),
              ),
              // Reflet lumineux
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.2),
                blurRadius: 25,
                spreadRadius: -5,
                offset: const Offset(0, -10),
              ),
              // Ombre interne pour profondeur
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.05),
                blurRadius: 1,
                spreadRadius: 0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Écran du téléphone
              Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: Column(
                    children: [
                      // Barre de statut simulée (notch area)
                      _buildStatusBar(),
                      
                      // Application
                      Expanded(
                        child: BlocProvider(
                          create: (context) => DemoBluetoothScanBloc(),
                          child: const MobileBluetoothScanScreen(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bouton home indicator iOS
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 44, // Hauteur standard status bar + safe area iPhone
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Heure simulée avec notch
            Row(
              children: [
                const Text(
                  '16:42',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            
            // Icônes de statut simulées style iOS
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 14),
                      const SizedBox(width: 2),
                      Icon(Icons.wifi, color: Colors.white, size: 14),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Stack(
                  children: [
                    Icon(Icons.battery_full, color: Colors.white, size: 20),
                    Positioned(
                      right: 2,
                      top: 4,
                      child: Container(
                        width: 10,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.green[400],
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
