import 'package:flutter_k/export.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({
    super.key,
  });

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const Promotion(),
    const ActivityScreen(),
    const AccountUser(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 14,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.redAccent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 35, color: Colors.black),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/Ticket_talon.png',
              height: 40,
              width: 40,
            ),
            label: 'โปรโมชั่น',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant, size: 35, color: Colors.black),
            label: 'กิจกรรม',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 35, color: Colors.black),
            label: 'บัญชีผู้ใช้',
          ),
        ],
      ),
    );
  }
}
