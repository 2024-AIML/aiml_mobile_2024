import 'package:flutter/material.dart';

class GuidelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('행동지침안내'), // Title of the AppBar
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Add padding around the image
                child: Image.asset(
                  'assets/image/disaster.png', // Replace with your actual image path
                  // Fit the image to cover the space
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GuidelinePage(),
  ));
}