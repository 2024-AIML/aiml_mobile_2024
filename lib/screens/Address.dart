// import 'package:flutter/material.dart';
// import '../service/LocationToAddress.dart';
//
// class AddressScreen extends StatefulWidget {
//   @override
//   _AddressScreenState createState() => _AddressScreenState();
// }
//
// class _AddressScreenState extends State<AddressScreen> {
//   final LocationToAddressService _service = LocationToAddressService();
//   String _currentAddress = 'Fetching address...';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Address Finder'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Current Address: $_currentAddress',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//             ElevatedButton(
//               onPressed: _fetchAndSendAddress,
//               child: Text('Get Address'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _fetchAndSendAddress() async {
//     try {
//       final position = await _service.getCurrentLocation();
//       final address = await _service.getAddressFromLatLng(
//         position.latitude,
//         position.longitude,
//       );
//       setState(() {
//         _currentAddress = address;
//       });
//       await _service.sendRequest(address);
//     } catch (e) {
//       print(e);
//     }
//   }
// }