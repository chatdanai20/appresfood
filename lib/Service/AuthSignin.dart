// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter_k/export.dart';

// class Profile {
//   late String email;
//   late String password;

//   Profile({required this.email, required this.password});
// }

// class AuthSignUpAndSignOut {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FacebookAuth _facebookAuth = FacebookAuth.instance;
//   late final BuildContext context;
//   Future<UserCredential> signInWithGoogle() async {
//     try {
//       // Log in with Google
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser != null) {
//         // Get the Google authentication token
//         final GoogleSignInAuthentication googleAuth =
//             await googleUser.authentication;
//         // Create a Firebase credential with the Google authentication token
//         final OAuthCredential googleAuthCredential =
//             GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         // Sign in to Firebase with the Google credential
//         final UserCredential userCredential = await FirebaseAuth.instance
//             .signInWithCredential(googleAuthCredential);
//         return userCredential;
//       } else {
//         throw 'User cancelled the login process';
//       }
//     } catch (error) {
//       print('Error during Google login: $error');
//       // Display an error message to the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error during Google login: $error'),
//         ),
//       );
//       throw 'Error during Google login: $error';
//     }
//   }

//   Future<UserCredential> signInWithFacebook() async {
//     try {
//       // Log in with Facebook
//       final LoginResult loginResult = await FacebookAuth.instance.login();
//       if (loginResult.status == LoginStatus.success) {
//         // Get the Facebook access token
//         final AccessToken accessToken = loginResult.accessToken!;
//         // Create a Firebase credential with the Facebook access token
//         final OAuthCredential facebookAuthCredential =
//             FacebookAuthProvider.credential(accessToken.token);
//         // Sign in to Firebase with the Facebook credential
//         final UserCredential userCredential = await FirebaseAuth.instance
//             .signInWithCredential(facebookAuthCredential);
//         return userCredential;
//       } else if (loginResult.status == LoginStatus.cancelled) {
//         throw 'User cancelled the login process';
//       } else {
//         throw 'Error during Facebook login: ${loginResult.message}';
//       }
//     } catch (error) {
//       print('เกิดข้อผิดพลาดระหว่างการลงชื่อเข้าใช้ facebook: $error');
//       throw 'เกิดข้อผิดพลาดระหว่างการลงชื่อเข้าใช้ facebook: $error';
//     }
//   }

//   Future<UserCredential> signUpWithEmail(Profile profile) async {
//     try {
//       return await _auth.createUserWithEmailAndPassword(
//           email: profile.email, password: profile.password);
//     } catch (error) {
//       print('เกิดข้อผิดพลาดในการสมัครสมาชิก: $error');
//       rethrow;
//     }
//   }

//   Future<UserCredential> signInWithEmail(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential;
//     } catch (error) {
//       print('Error signing in with email and password: $error');
//       throw 'เกิดข้อผิดพลาดในการลงชื่อเข้าใช้ด้วยอีเมลและรหัสผ่าน';
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       await _googleSignIn.signOut();
//       // await _facebookAuth.logOut();
//     } catch (error) {
//       print('เกิดข้อผิดพลาดในการออกจากระบบ: $error');
//       rethrow;
//     }
//   }
// }
