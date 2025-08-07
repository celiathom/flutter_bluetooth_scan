import 'package:flutter/material.dart';
import '../models/bluetooth_device_model.dart';

class MobileBluetoothDeviceCard extends StatelessWidget {
  final BluetoothDeviceModel device;

  const MobileBluetoothDeviceCard({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icône d'appareil avec couleur de signal
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getRssiColor(device.rssi).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getDeviceIcon(device.name),
                color: _getRssiColor(device.rssi),
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Informations de l'appareil
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1a1a1a),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDeviceId(device.id),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Il y a ${_formatTime(device.lastSeen)}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Indicateur de signal moderne
            Column(
              children: [
                _buildSignalIndicator(device.rssi),
                const SizedBox(height: 4),
                Text(
                  '${device.rssi} dBm',
                  style: TextStyle(
                    color: _getRssiColor(device.rssi),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalIndicator(int rssi) {
    Color signalColor = _getRssiColor(rssi);
    int signalBars = _getSignalBars(rssi);
    
    return Row(
      children: List.generate(4, (index) {
        bool isActive = index < signalBars;
        return Container(
          width: 3,
          height: 8 + (index * 3).toDouble(),
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: isActive ? signalColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(1.5),
          ),
        );
      }),
    );
  }

  IconData _getDeviceIcon(String deviceName) {
    String name = deviceName.toLowerCase();
    
    if (name.contains('airpods') || name.contains('headphone') || name.contains('earbuds')) {
      return Icons.headphones;
    } else if (name.contains('watch') || name.contains('band')) {
      return Icons.watch;
    } else if (name.contains('phone') || name.contains('iphone') || name.contains('samsung')) {
      return Icons.smartphone;
    } else if (name.contains('speaker')) {
      return Icons.speaker;
    } else if (name.contains('mouse') || name.contains('keyboard')) {
      return Icons.computer;
    } else if (name.contains('tv') || name.contains('display')) {
      return Icons.tv;
    } else if (name.contains('car') || name.contains('auto')) {
      return Icons.directions_car;
    } else {
      return Icons.bluetooth;
    }
  }

  Color _getRssiColor(int rssi) {
    if (rssi >= -50) {
      return const Color(0xFF4CAF50); // Vert
    } else if (rssi >= -70) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Rouge
    }
  }

  int _getSignalBars(int rssi) {
    if (rssi >= -40) return 4;
    if (rssi >= -55) return 3;
    if (rssi >= -70) return 2;
    if (rssi >= -85) return 1;
    return 0;
  }

  String _formatDeviceId(String id) {
    // Formats l'ID pour qu'il soit plus lisible
    if (id.length > 17) {
      return '${id.substring(0, 8)}...${id.substring(id.length - 8)}';
    }
    return id;
  }

  String _formatTime(DateTime? time) {
    if (time == null) return 'Inconnu';
    
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}min';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else {
      return '${diff.inDays}j';
    }
  }
}
