import 'package:flutter_k/Providers/providerMenu.dart';
import 'package:flutter_k/Screens/Editmenu/ExtraEdit/EditExtramenuScreen.dart';
import 'package:flutter_k/export.dart';

class EditMenuScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;
  final String email;
  final List<dynamic> cartItems;
  final int numberOfPeople;
  final String user;

  const EditMenuScreen({
    Key? key,
    required this.orderData,
    required this.email,
    required this.cartItems,
    required this.numberOfPeople,
    required this.user,
  }) : super(key: key);

  @override
  _EditMenuScreenState createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Menu')
            .where('email', isEqualTo: widget.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ไม่มีรายการอาหาร'));
          }

          List<MenuFood> menuFoods = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            List<Map<String, String>> extras = [];
            if (data.containsKey('extras')) {
              extras = List<Map<String, String>>.from(
                data['extras'].map(
                  (extraItem) => Map<String, String>.from(extraItem),
                ),
              );
            }

            return MenuFood(
              name: data.containsKey('name') ? (data['name'] as String) : "",
              price: data.containsKey('price')
                  ? ((data['price'] is String)
                      ? int.parse(data['price'] as String)
                      : data['price'] as int)
                  : 0,
              image: data.containsKey('image') ? (data['image'] as String) : "",
              options: data.containsKey('options')
                  ? List<String>.from(data['options'])
                  : [],
              userId:
                  data.containsKey('email') ? (data['email'] as String) : "",
              extras: extras,
            );
          }).toList();

          return SafeArea(
            child: MenuList(menuFoods: menuFoods, user: widget.user),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.redAccent,
      title: const Text("แก้ไขเมนูอาหาร"),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class MenuList extends StatelessWidget {
  final List<MenuFood> menuFoods;
  final String user;

  const MenuList({Key? key, required this.menuFoods, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ListView.builder(
          itemCount: menuFoods.length,
          itemBuilder: (context, index) {
            MenuFood foodData = menuFoods[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditExtraMenuSelect(
                        foodData: foodData, user: user), // Pass user here
                  ),
                );
              },
              child: MenuItem(
                foodData: foodData,
              ),
            );
          },
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final MenuFood foodData;

  const MenuItem({
    Key? key,
    required this.foodData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.pinkAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              height: 100,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(foodData.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodData.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ราคา : ${foodData.price} บาท",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
