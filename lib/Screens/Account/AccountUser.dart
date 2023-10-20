import 'package:flutter_k/export.dart';

class AccountUser extends StatefulWidget {
  const AccountUser({Key? key}) : super(key: key);

  @override
  State<AccountUser> createState() => _AccountUserState();
}

class _AccountUserState extends State<AccountUser> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Auth authgoogle = Auth(context, onLoginSuccess: () {});
    Auth authfacebook = Auth(context, onLoginSuccess: () {});
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 5,
        title: const Text(
          'บัญชีผู้ใช้',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildOption(
            'บัญชีผู้ใช้',
            Icons.account_circle,
            () {
              Navigator.pushNamed(context, AppRoute.user);
            },
          ),
          buildOption(
            'ตั้งค่า',
            Icons.settings,
            () {
              Navigator.pushNamed(context, AppRoute.setting);
            },
          ),
          buildOption(
            'ออกจากระบบ',
            Icons.logout,
            () {
              auth.signOut().then(
                    (value) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    ),
                  );
              authgoogle.handleLogout();
              authfacebook.handleLogout();
            },
          ),
        ],
      ),
    );
  }

  Widget buildOption(String title, IconData icon, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.redAccent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
