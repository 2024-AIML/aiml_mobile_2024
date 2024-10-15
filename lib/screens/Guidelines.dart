import 'package:flutter/material.dart';
import 'package:aiml_mobile_2024/screens/DisasterGuideline.dart';
import 'package:aiml_mobile_2024/screens/WarGuideline.dart';
import 'package:aiml_mobile_2024/screens/SuppliesGuideline.dart';
import 'package:aiml_mobile_2024/screens/CprGuideline.dart';

class GuidelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('행동지침안내'), // Title of the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            // First image and text
            _buildGridItem(
              context,
              '자연재해 발생시 행동요령',
              'assets/image/disaster.png',
              DisasterGuideline(),
            ),
            // Second image and text
            _buildGridItem(
              context,
              '전쟁시 행동요령',
              'assets/image/war.png',
              WarGuideline(),
            ),
            // Third image and text
            _buildGridItem(
              context,
              '대피용품안내',
              'assets/image/supplies.png',
              SuppliesguidelineScreen(),
            ),
            // Fourth image and text
            _buildGridItem(
              context,
              '심폐소생술',
              'assets/image/cpr.png',
              CprGuideline(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, String imagePath, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        height: 150, // Set a fixed height for each item
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green), // Optional: add border for visibility
          borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 80, // Image height
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
