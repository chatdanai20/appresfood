// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter_k/export.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '');
  late Future<FirebaseApp> firebase;

  @override
  void initState() {
    super.initState();
    firebase = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: const Color(0xFFFCE7E2),
            body: SafeArea(
              child: Column(
                children: [
                  _buildCancelButton(),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLogo(),
                              _buildEmailField(),
                              const SizedBox(height: 10),
                              _buildPasswordField(),
                              const SizedBox(height: 50),
                              _buildRegisterButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(Object? error) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Error"),
      ),
      body: Center(
        child: Text(
          "$error",
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(
            Icons.cancel,
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return const Center(
      child: Image(
        image: AssetImage('assets/images/Logoapp.png'),
        height: 200,
        width: 200,
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("อีเมล", style: TextStyle(fontSize: 18)),
        TextFormField(
          validator: MultiValidator(
            [
              RequiredValidator(
                errorText: "กรุณาใส่อีเมล",
              ),
              EmailValidator(
                errorText: "กรุณาใส่อีเมลให้ถูกต้อง",
              ),
            ],
          ),
          keyboardType: TextInputType.emailAddress,
          onSaved: (email) {
            profile.email = email!;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("รหัสผ่าน", style: TextStyle(fontSize: 18)),
        TextFormField(
          validator: RequiredValidator(
            errorText: "กรุณาใส่รหัสผ่าน",
          ),
          obscureText: true,
          onSaved: (password) {
            profile.password = password!;
          },
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent,
          ),
          child: const Text(
            "ลงทะเบียน",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              try {
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                  email: profile.email,
                  password: profile.password,
                )
                    .then((value) {
                  formKey.currentState!.reset();
                  // CherryToast(
                  //   icon: Icons.check_circle_outline,
                  //   title: const Text(
                  //     'ลงทะเบียนสำเร็จ',
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  );
                });
              } on FirebaseAuthException catch (e) {
                String message;
                double height = e.code == 'weak-password' ? 75 : 100;
                if (e.code == 'weak-password') {
                  message = "รหัสผ่านต้องไม่น้อยกว่า 6 ตัว";
                } else if (e.code == 'email-already-in-use') {
                  message = "อีเมลนี้ถูกใช้งานแล้ว โปรดใช้อีเมลอื่น";
                } else {
                  message = "เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง";
                }
                // CherryToast(
                //   icon: Icons.cancel_outlined,
                //   title: Text(
                //     message,
                //     style: const TextStyle(
                //       color: Colors.black,
                //       fontSize: 22,
                //     ),
                //   ),
                //   displayCloseButton: false,
                //   toastDuration: const Duration(seconds: 3),
                //   animationDuration: const Duration(milliseconds: 1000),
                //   animationType: AnimationType.fromTop,
                //   themeColor: Colors.pink,
                //   autoDismiss: true,
                //   width: 400,
                //   height: height,
                //   iconSize: 40,
                //   iconColor: Colors.red,
                // ).show(context);
                // print(e.code);
                // print(e.message);
              }
            }
          },
        ),
      ),
    );
  }
}
