import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../theme/app_theme.dart';

class OSMMapScreen extends StatefulWidget {
  const OSMMapScreen({super.key});

  @override
  State<OSMMapScreen> createState() => _OSMMapScreenState();
}

class _OSMMapScreenState extends State<OSMMapScreen> {
  late MapController _mapController;
  GeoPoint? _selectedLocation;
  String _locationName = 'Select a location';

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      initPosition: GeoPoint(
        latitude: 16.5062,
        longitude: 80.6480,
      ), // Andhra Pradesh center
      areaLimit: const BoundingBox(east: 84.0, north: 20.0, south: 13.0, west: 77.0),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation(GeoPoint point) async {
    setState(() {
      _selectedLocation = point;
      _locationName =
          '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}';
    });

    // Note: searchAddressReverse is not available in the current version
    // We'll just use the coordinates for now
    try {
      // This would be the ideal implementation if the method was available:
      // final addresses = await _mapController.searchAddressReverse(point);
      // if (addresses.isNotEmpty) {
      //   setState(() {
      //     _locationName = addresses.first.address?.city ?? _locationName;
      //   });
      // }
    } catch (e) {
      // If reverse geocoding fails, we'll use the coordinates
      print('Error getting address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Farm Location')),
      body: Column(
        children: [
          Expanded(
            child: OSMFlutter(
              controller: _mapController,
              osmOption: const OSMOption(
                zoomOption: ZoomOption(
                  initZoom: 8,
                  minZoomLevel: 5,
                  maxZoomLevel: 18,
                  stepZoom: 1.0,
                ),
                userTrackingOption: UserTrackingOption(enableTracking: false),
              ),
              onMapIsReady: (isReady) {
                if (isReady) {
                  print('Map is ready');
                }
              },
              onGeoPointClicked: (point) async {
                await _pickLocation(point);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: Column(
              children: [
                Text(
                  _locationName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      _selectedLocation == null
                          ? null
                          : () {
                            Navigator.pop(context, _locationName);
                          },
                  child: const Text('Confirm Location'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
