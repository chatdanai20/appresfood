import 'package:flutter_k/export.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('บัญชีผู้ใช้'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            FirebaseAuth.instance.currentUser!.email.toString(),
          ),
        ),
      ),
    );
  }
}
