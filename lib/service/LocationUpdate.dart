import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationUpdate {
  Timer? _timer;
  Function(Position)? onLocationUpdate;

  void updateLocation() {
    _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) async {
      Position position = await _getCurrentLocation();
      print('현재위치: ${position.latitude}, ${position.longitude}');
      if (onLocationUpdate != null) {
        onLocationUpdate!(position);  // Notify the listener of the location update
      }
    });
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  void dispose() {
    _timer?.cancel();  // Stop the timer when no longer needed
  }
}

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final LocationUpdate _locationService = LocationUpdate();
  Position? _currentPosition;  // To store the current position

  @override
  void initState() {
    super.initState();
    _locationService.onLocationUpdate = (Position position) {
      setState(() {
        _currentPosition = position;  // Update the UI when location changes
      });
    };
    _locationService.updateLocation();
  }

  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Service')),
      body: Center(
        child: _currentPosition == null
            ? Text('Updating your location...')
            : Text(
          'Current Location: \nLatitude: ${_currentPosition!.latitude}, \nLongitude: ${_currentPosition!.longitude}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}