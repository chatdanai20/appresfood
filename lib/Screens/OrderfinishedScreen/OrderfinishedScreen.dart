import 'package:flutter_k/Screens/mapScreen/Map.dart';
import 'package:flutter_k/export.dart';

class OrderfinishedScreen extends StatelessWidget {
  const OrderfinishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    navigateToMapScreen(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ยืนยันการจองแล้ว'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.redAccent,
        elevation: 3,
      ),
      body: Container(
        child: const Center(
          child: Text(
            "ยืนยันการจองแล้ว",
          ),
        ),
      ),
    );
  }
}

void navigateToMapScreen(BuildContext context) {
  Future.delayed(const Duration(seconds: 3), () {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MapSample(),
      ),
    );
  });
}
