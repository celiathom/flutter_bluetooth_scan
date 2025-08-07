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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Bluetooth Scanner',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<DemoBluetoothScanBloc, BluetoothScanState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildSimpleButton(context, state),
                const SizedBox(height: 20),
                _buildSimpleStatus(state),
                const SizedBox(height: 20),
                Expanded(
                  child: _buildSimpleDevicesList(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSimpleButton(BuildContext context, BluetoothScanState state) {
    bool isScanning = state is BluetoothScanScanning;
    
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (isScanning) {
            context.read<DemoBluetoothScanBloc>().add(const StopScanEvent());
          } else {
            context.read<DemoBluetoothScanBloc>().add(const StartScanEvent());
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isScanning ? Colors.red : Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          isScanning ? 'ARRÊTER' : 'SCANNER',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleStatus(BluetoothScanState state) {
    if (state is BluetoothScanScanning) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green, width: 1),
        ),
        child: Row(
          children: [
            const CircularProgressIndicator(
              color: Colors.green,
              strokeWidth: 2,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Scan en cours... ${state.devices.length} appareils trouvés',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: const Row(
        children: [
          Icon(Icons.bluetooth, color: Colors.grey),
          SizedBox(width: 12),
          Text(
            'Prêt à scanner',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleDevicesList(BuildContext context, BluetoothScanState state) {
    List<dynamic> devices = [];

    if (state is BluetoothScanScanning) {
      devices = state.devices;
    } else if (state is BluetoothScanStopped) {
      devices = state.devices;
    }

    // Log all detected devices for debugging purposes
    print('Appareils détectés : ${devices.map((device) => device.name).toList()}');

    if (devices.isEmpty) {
      return const Center(
        child: Text(
          'Aucun appareil trouvé',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return _buildSimpleDeviceCard(devices[index]);
      },
    );
  }

  Widget _buildSimpleDeviceCard(dynamic device) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            _getDeviceIcon(device.name),
            color: Colors.blue,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  device.id,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getSignalColor(device.rssi),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${device.rssi}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(String deviceName) {
    String name = deviceName.toLowerCase();
    
    if (name.contains('airpods')) {
      return Icons.headphones;
    } else if (name.contains('watch') || name.contains('band')) {
      return Icons.watch;
    } else if (name.contains('iphone') || name.contains('phone')) {
      return Icons.smartphone;
    } else if (name.contains('macbook') || name.contains('laptop')) {
      return Icons.laptop;
    } else {
      return Icons.bluetooth;
    }
  }

  Color _getSignalColor(int rssi) {
    if (rssi >= -50) {
      return Colors.green;
    } else if (rssi >= -70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
