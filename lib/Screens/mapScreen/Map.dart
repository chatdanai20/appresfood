import 'package:flutter_k/export.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late CameraPosition position;
  Location location = Location();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 25,
  );
  void getlocation() async {
    Location location = Location();
    try {
      var locationData = await location.getLocation();
      print(locationData);
      final newPosition = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(locationData.latitude!, locationData.longitude!),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414,
      );
      setState(() {
        position = newPosition;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getlocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Maps Sample App'),
      //   centerTitle: true,
      //   backgroundColor: Colors.redAccent,
      //   elevation: 3,
      // ),
      body: SafeArea(
        child: GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    Location location = Location();
    var locationData = await location.getLocation();
    print(locationData);
    final GoogleMapController controller = await _controller.future;
    final newPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(locationData.latitude!, locationData.longitude!),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }
}
