import 'package:flutter_k/export.dart';

class StepActivity extends StatefulWidget {
  const StepActivity({super.key});

  @override
  State<StepActivity> createState() => _StepActivityState();
}

class _StepActivityState extends State<StepActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('รายการกิจกรรม'),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: const Center(
          child: Text('Step Activity'),
        ));
  }
}
