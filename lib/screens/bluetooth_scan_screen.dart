import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bluetooth_scan_bloc.dart';
import '../bloc/bluetooth_scan_event.dart';
import '../bloc/bluetooth_scan_state.dart';
import '../widgets/bluetooth_device_card.dart';

class BluetoothScanScreen extends StatelessWidget {
  const BluetoothScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scanner Bluetooth',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        actions: [
          BlocBuilder<BluetoothScanBloc, BluetoothScanState>(
            builder: (context, state) {
              if (state is BluetoothScanStopped || state is BluetoothScanScanning) {
                return IconButton(
                  icon: const Icon(Icons.clear_all, color: Colors.white),
                  onPressed: () {
                    context.read<BluetoothScanBloc>().add(const ClearDevicesEvent());
                  },
                  tooltip: 'Effacer la liste',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<BluetoothScanBloc, BluetoothScanState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildStatusCard(context, state),
              _buildControlButton(context, state),
              Expanded(
                child: _buildDevicesList(context, state),
              ),
            ],
          );
        },
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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w500,
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: canScan
            ? () {
                if (isScanning) {
                  context.read<BluetoothScanBloc>().add(const StopScanEvent());
                } else {
                  context.read<BluetoothScanBloc>().add(const StartScanEvent());
                }
              }
            : null,
        icon: Icon(
          isScanning ? Icons.stop : Icons.bluetooth_searching,
          color: Colors.white,
        ),
        label: Text(
          isScanning ? 'Arrêter le scan' : 'Démarrer le scan',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isScanning ? Colors.red[600] : Colors.blue[600],
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          disabledBackgroundColor: Colors.grey[400],
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
            Icon(
              Icons.bluetooth_disabled,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun appareil détecté',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Démarrez un scan pour rechercher des appareils Bluetooth à proximité',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return BluetoothDeviceCard(device: devices[index]);
      },
    );
  }
}
