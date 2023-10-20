import 'package:flutter_k/export.dart';

class AuthHome extends StatelessWidget {
  const AuthHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return const BottomNav();
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
