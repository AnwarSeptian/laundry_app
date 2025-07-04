import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HalamanMaps extends StatefulWidget {
  const HalamanMaps({super.key});

  @override
  State<HalamanMaps> createState() => _HalamanMapsState();
}

class _HalamanMapsState extends State<HalamanMaps> {
  GoogleMapController? mapController;
  final LatLng _currentPosition = LatLng(-6.200000, 106.816666);
  final String _currentAddress = "Alamat tidak di temukan";
  Marker? _marker;

  Future<void> _getCurrentLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
