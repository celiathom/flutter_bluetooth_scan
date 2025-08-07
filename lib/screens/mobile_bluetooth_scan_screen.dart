import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/demo_bluetooth_scan_bloc.dart';
import '../bloc/bluetooth_scan_event.dart';
import '../bloc/bluetooth_scan_state.dart';
import '../widgets/mobile_bluetooth_device_card.dart';

class MobileBluetoothScanScreen extends StatelessWidget {
  const MobileBluetoothScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scanner Bluetooth',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 56,
        actions: [
          BlocBuilder<DemoBluetoothScanBloc, BluetoothScanState>(
            builder: (context, state) {
              if (state is BluetoothScanStopped || state is BluetoothScanScanning) {
                return IconButton(
                  icon: const Icon(Icons.clear_all, color: Colors.white, size: 22),
                  onPressed: () {
                    context.read<DemoBluetoothScanBloc>().add(const ClearDevicesEvent());
                  },
                  tooltip: 'Effacer la liste',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      
      body: Column(
        children: [
          _buildMobileStatusBar(),
          Expanded(
            child: BlocBuilder<DemoBluetoothScanBloc, BluetoothScanState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildStatusCard(context, state),
                    _buildControlButton(context, state),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _buildDevicesList(context, state),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      
      bottomNavigationBar: Container(
        height: 34,
        color: Colors.white,
        child: Center(
          child: Container(
            width: 134,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileStatusBar() {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, BluetoothScanState state) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (state is BluetoothUnavailable) {
      statusText = state.message;
      statusColor = Colors.red;
      statusIcon = Icons.bluetooth_disabled;
    } else if (state is BluetoothScanError) {
      statusText = state.message;
      statusColor = Colors.red;
      statusIcon = Icons.error;
    } else if (state is BluetoothScanScanning) {
      statusText = 'Scan en cours... ${state.devices.length} appareil(s) trouvé(s)';
      statusColor = Colors.green;
      statusIcon = Icons.bluetooth_searching;
    } else if (state is BluetoothScanStopped) {
      statusText = 'Scan arrêté - ${state.devices.length} appareil(s) trouvé(s)';
      statusColor = Colors.blue;
      statusIcon = Icons.bluetooth;
    } else if (state is BluetoothScanLoading) {
      statusText = 'Initialisation du scan...';
      statusColor = Colors.orange;
      statusIcon = Icons.bluetooth_searching;
    } else {
      statusText = 'Prêt à scanner';
      statusColor = Colors.grey;
      statusIcon = Icons.bluetooth;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          if (state is BluetoothScanScanning)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton(BuildContext context, BluetoothScanState state) {
    bool isScanning = state is BluetoothScanScanning;
    bool canScan = state is! BluetoothUnavailable && state is! BluetoothScanLoading;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 56,
      child: ElevatedButton(
        onPressed: canScan
            ? () {
                if (isScanning) {
                  context.read<DemoBluetoothScanBloc>().add(const StopScanEvent());
                } else {
                  context.read<DemoBluetoothScanBloc>().add(const StartScanEvent());
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isScanning ? Colors.red[500] : Colors.blue[600],
          foregroundColor: Colors.white,
          elevation: isScanning ? 4 : 2,
          shadowColor: isScanning ? Colors.red[300] : Colors.blue[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isScanning ? Icons.stop_circle : Icons.bluetooth_searching,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              isScanning ? 'Arrêter le scan' : 'Démarrer le scan',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevicesList(BuildContext context, BluetoothScanState state) {
    List<dynamic> devices = [];

    if (state is BluetoothScanScanning) {
      devices = state.devices;
    } else if (state is BluetoothScanStopped) {
      devices = state.devices;
    } else if (state is BluetoothScanError) {
      devices = state.devices;
    }

    if (devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bluetooth_disabled,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun appareil détecté',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Démarrez un scan pour rechercher des appareils Bluetooth à proximité',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: MobileBluetoothDeviceCard(device: devices[index]),
        );
      },
    );
  }
}
