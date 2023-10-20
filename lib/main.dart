import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: UtlAssignment(),
    );
  }
}

class UtlAssignment extends StatefulWidget {
  @override
  _UtlAssignmentState createState() => _UtlAssignmentState();
}

class _UtlAssignmentState extends State<UtlAssignment> {
  late GoogleMapController mapController;
  double searchBarHeight = 90.0;
  // String imagePath = "assets/bike_img.png";
  final LatLng sourceLocation = const LatLng(22.569711629453256, 88.36049180531727); // Replace with your source coordinates
  final LatLng destinationLocation = const LatLng(22.571217507890523, 88.35582476154605); // Replace with your destination coordinates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location_outlined),
      onPressed: (){
      },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      // ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: sourceLocation,
          zoom: 30.0,
        ),
        markers: Set<Marker>.from([
          Marker(
            markerId: MarkerId("sourceMarker"),
            position: sourceLocation,
            //infoWindow: InfoWindow(title: "Source"),
            // onTap: (){},
            onTap: () {
              _showCustomPopup(context, "assets/bike_img.png");
            },
          ),
          Marker(
            markerId: MarkerId("destinationMarker"),
            position: destinationLocation,
            //infoWindow: InfoWindow(title: "Destination"),
            onTap: () {
              _showCustomPopup(context, "assets/bike_img.png");
            },
          ),
        ]),
        polylines: Set<Polyline>.from([
          Polyline(
            polylineId: PolylineId("path"),
            color: Colors.blue,
            points: [sourceLocation, destinationLocation],
          ),
        ]),
      ),
      bottomSheet:
        GestureDetector(
          onTap: () {
            _showBottomSheet(context);
          },
          child: Container(
            color: Colors.lightGreen,
            height: searchBarHeight,
            child: Column(
              children: [
                SizedBox(height: 8,),
                Center(child:
                Icon(Icons.straighten_rounded)
                ),
                Text('tap here to search'),
              ],
            ),
          ),
        ),
      // Icon(Icons.add),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _showCustomPopup(BuildContext context, String imagePath) {
    final overlay = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        top: 100,
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(16.0),
            width: 300,
            child: Row(
              children: [
                Image.asset(
                  imagePath,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      "400 m",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Jason E - Kick Scooter",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlay);

    // Close the overlay after a short delay (e.g., 3 seconds)
    Future.delayed(Duration(seconds: 3), () {
      overlay.remove();
    });
  }

  void _showBottomSheet(BuildContext context) {
    setState(() {
      searchBarHeight = 90.0;//MediaQuery.of(context).size.height * 0.3;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ExpandableBottomSheet();
        /*  SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search by Address',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );*/
      },
    );
  }
}

class ExpandableBottomSheet extends StatefulWidget {
  @override
  _ExpandableBottomSheetState createState() => _ExpandableBottomSheetState();
}

class _ExpandableBottomSheetState extends State<ExpandableBottomSheet> {
  bool isExpanded = false;

  @override

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        color: Colors.lightGreen,
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Icon(Icons.straighten_rounded)),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search Destination', // Hint text
                  labelText: 'Search by Address', // Optional label text
                  border: OutlineInputBorder(), // Optional border
                ),
              ),
              if (isExpanded) ...[
                SizedBox(height: 8.0),
                Card(
                  margin: EdgeInsets.all(4.0),
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/bike_img.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 16.0),
                            Text(
                              "400 m",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "Jason E - Kick Scooter",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(4.0),
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/bike_img.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 16.0),
                            Text(
                              "400 m",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "Jason E - Kick Scooter",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(4.0),
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/bike_img.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 16.0),
                            Text(
                              "400 m",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "Jason E - Kick Scooter",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

      ),
    );
  }
}