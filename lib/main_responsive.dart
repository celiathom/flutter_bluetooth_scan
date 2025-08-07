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
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => DemoBluetoothScanBloc(),
        child: const ResponsiveMobileFrame(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ResponsiveMobileFrame extends StatelessWidget {
  const ResponsiveMobileFrame({super.key});

  @override
  Widget build(BuildContext context) {
    // Détecte si on est sur web/desktop ou mobile
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;

    if (isDesktop) {
      // Version desktop avec cadre mobile simulé
      return const DesktopMobileSimulator();
    } else {
      // Version mobile native
      return const MobileBluetoothScanScreen();
    }
  }
}

class DesktopMobileSimulator extends StatelessWidget {
  const DesktopMobileSimulator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 850,
          ),
          width: 390,
          height: 844,
          decoration: BoxDecoration(
            color: const Color(0xFF2c2c2e),
            borderRadius: BorderRadius.circular(45),
            border: Border.all(
              color: const Color(0xFF4a4a4c),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.7),
                blurRadius: 50,
                spreadRadius: 0,
                offset: const Offset(0, 25),
              ),
              BoxShadow(
                color: Colors.cyan.withValues(alpha: 0.1),
                blurRadius: 30,
                spreadRadius: -10,
                offset: const Offset(0, -15),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Notch iPhone style
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2c2c2e),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(42),
                      topRight: Radius.circular(42),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 6,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1c1c1e),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Écran principal
              Container(
                margin: const EdgeInsets.only(
                  top: 35,
                  left: 6,
                  right: 6,
                  bottom: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(38),
                  child: const MobileBluetoothScanScreen(),
                ),
              ),
              
              // Bouton power (côté droit)
              Positioned(
                right: -2,
                top: 150,
                child: Container(
                  width: 4,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4a4a4c),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Boutons volume (côté gauche)
              Positioned(
                left: -2,
                top: 120,
                child: Container(
                  width: 4,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4a4a4c),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Positioned(
                left: -2,
                top: 180,
                child: Container(
                  width: 4,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4a4a4c),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
