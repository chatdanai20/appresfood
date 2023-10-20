import 'package:flutter_k/export.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final BuildContext context;
  final VoidCallback onLoginSuccess;

  Auth(this.context, {required this.onLoginSuccess});

  Future<void> handleGoogleSignIn() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await auth.signInWithCredential(credential);
        showSuccessToast();
        navigateToBottomNav();
        onLoginSuccess();
      }
    } catch (error) {
      print('เกิดข้อผิดพลาดระหว่างการลงชื่อเข้าใช้: $error');
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    final result = await facebookAuth.login();
    if (result.status == LoginStatus.success) {
      final credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      await auth.signInWithCredential(credential);
      showSuccessToast();
      navigateToBottomNav();
      onLoginSuccess(); // Call the callback function
      return null;
    }
    showSuccessToast();
    navigateToBottomNav();
    return null;
  }

  Future<void> handleLogout() async {
    try {
      await auth.signOut().then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const WelcomeScreen();
              },
            ),
          ));
      await googleSignIn.signOut().then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const WelcomeScreen();
              },
            ),
          ));
      await facebookAuth.logOut().then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const WelcomeScreen();
              },
            ),
          ));
    } catch (error) {
      print('เกิดข้อผิดพลาดระหว่างการลงชื่อเข้าใช้: $error');
    }
  }

  void showSuccessToast() {
    // CherryToast(
    //   icon: Icons.check_circle_outline,
    //   title: const Text(
    //     'เข้าสู่ระบบสำเร็จ',
    //     style: TextStyle(
    //       color: Colors.black,
    //       fontSize: 25,
    //     ),
    //   ),
    //   displayCloseButton: false,
    //   toastDuration: const Duration(seconds: 2),
    //   animationDuration: const Duration(milliseconds: 1000),
    //   animationType: AnimationType.fromTop,
    //   themeColor: Colors.pink,
    //   autoDismiss: true,
    //   width: 400,
    //   height: 75,
    //   iconSize: 40,
    //   iconColor: Colors.green,
    // ).show(context);
  }

  void navigateToBottomNav() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const BottomNav();
        },
      ),
    );
  }
}
