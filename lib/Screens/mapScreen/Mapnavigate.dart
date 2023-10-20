import 'package:flutter_k/Screens/review/reviewscreen.dart';
import 'package:flutter_k/export.dart';

class MapNavigate extends StatefulWidget {
  final String email;
  const MapNavigate({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _MapNavigateState createState() => _MapNavigateState();
}

class _MapNavigateState extends State<MapNavigate> {
  CameraPosition _position = const CameraPosition(
    target: LatLng(19.02796133580664, 99.985749655962),
    zoom: 19,
  );
  final Location _location = Location();
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getRestaurantLocation();
    _goToUserLocation();
  }

  Future<void> _getRestaurantLocation() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('RestaurantApp')
          .where('email', isEqualTo: widget.email)
          .get();

      if (query.docs.isNotEmpty) {
        var doc = query.docs.first;

        if (doc['latitude'] != null && doc['longitude'] != null) {
          double latitude = doc['latitude'].toDouble();
          double longitude = doc['longitude'].toDouble();
          LatLng destination = LatLng(latitude, longitude);
          setState(() {
            _markers.add(Marker(
              markerId: const MarkerId('restaurant'),
              position: destination,
              infoWindow: const InfoWindow(title: 'Restaurant'),
            ));
          });
          _addPolyline(destination);
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ReviewPage(),
          ),
        );
      }
    } catch (e) {
      print("Error getting restaurant location: $e");
    }
  }

  void _getUserLocation() async {
    try {
      var locationData = await _location.getLocation();
      setState(() {
        _position = CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 19.151926040649414,
        );
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _goToUserLocation() async {
    try {
      var locationData = await _location.getLocation();
      final GoogleMapController controller = await _controller.future;
      final newPosition = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 15.951926040649414,
      );
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(newPosition));
    } catch (e) {
      print("Error going to user location: $e");
    }
  }

  void _addPolyline(LatLng destination) async {
    var locationData = await _location.getLocation();
    LatLng origin = LatLng(locationData.latitude!, locationData.longitude!);

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId("route1"),
          points: [origin, destination],
          color: Colors.blue,
          width: 3,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แผนที่'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _position,
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
                _goToUserLocation();
              },
              markers: _markers,
              polylines: _polylines,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ReviewPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                  ),
                  child: const Text('รีวิว', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
