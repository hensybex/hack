import 'package:flutter/material.dart';
import 'package:hack/models/office.dart';
import 'package:hive/hive.dart';

class TalonsScreen extends StatefulWidget {
  final String officeId;

  TalonsScreen({required this.officeId});

  @override
  State<TalonsScreen> createState() => _TalonsScreenState();
}

class _TalonsScreenState extends State<TalonsScreen> {
  Office? office;
  Office? getOfficeById(int officeId) {
    final officeBox = Hive.box<Office>('offices');
    return officeBox.values.firstWhere(
      (office) => office.id == officeId,
      orElse: () {
        Office defaultOffice = Office(
          id: -1,
          salePointName: 'Default Office',
          address: 'Default Address',
          status: 'Default Status',
          openHours: [Hours(days: 'Mon-Fri', hours: '9:00-18:00')],
          rko: 'Default RKO',
          openHoursIndividual: [Hours(days: 'Mon-Fri', hours: '9:00-18:00')],
          officeType: 'Default Type',
          salePointFormat: 'Default Format',
          suoAvailability: 'Default SUO Availability',
          hasRamp: 'Default Ramp',
          latitude: 0.0,
          longitude: 0.0,
          metroStation: 'Default Metro',
          distance: 0,
          kep: false,
          myBranch: false,
          radiusDistance: 0.0,
          service: [],
        );
        return defaultOffice;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Talons Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    // Add your back button functionality here
                  },
                ),
                Text('Title 1'),
                Text('Title 2'),
              ],
            ),
            Text('Description Text'),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  color: Color(0xFF282B32),
                  child: Center(
                    child: Text('Custom Text 1'),
                  ),
                ),
                SizedBox(width: 16.0),
                Container(
                  width: 150,
                  height: 150,
                  color: Color(0xFF282B32),
                  child: Center(
                    child: Text('Custom Text 2'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Center(
              child: Text(
                'Centered Text',
                style: TextStyle(fontSize: 50),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Office ID: ${widget.officeId}'),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add your "Маршрут" button functionality here
                  },
                  child: Text('Маршрут'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your "На главную" button functionality here
                  },
                  child: Text('На главную'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
