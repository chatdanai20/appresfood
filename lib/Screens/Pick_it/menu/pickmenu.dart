import 'package:flutter_k/Providers/providerMenu.dart';
import 'package:flutter_k/Screens/Pick_it/cart/pickCart.dart';
import 'package:flutter_k/Screens/Pick_it/extra/pickExtra.dart';
import 'package:flutter_k/export.dart';
import 'package:badges/badges.dart' as badges;

class PickMenuScreen extends StatefulWidget {
  final List<Cart> cartItems;
  final String email;
  const PickMenuScreen({
    Key? key,
    required this.cartItems,
    required this.email,
  }) : super(key: key);

  @override
  State<PickMenuScreen> createState() => _PickMenuScreenState();
}

class _PickMenuScreenState extends State<PickMenuScreen> {
  @override
  void initState() {
    super.initState();
  }

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
            child: MenuList(menuFoods: menuFoods),
          );
        },
      ),
      floatingActionButton: CartFloatingActionButton(
        itemCount: cartProvider.carts.length,
        email: widget.email,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.redAccent,
      title: const Text("เมนูอาหาร"),
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

  const MenuList({Key? key, required this.menuFoods}) : super(key: key);

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
                    builder: (context) =>
                        PickExtraMenuSelect(foodData: foodData),
                  ),
                );
              },
              child: MenuItem(foodData: foodData),
            );
          },
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final MenuFood foodData;

  const MenuItem({Key? key, required this.foodData}) : super(key: key);

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

class CartFloatingActionButton extends StatelessWidget {
  final int itemCount;
  final String email;

  const CartFloatingActionButton({
    Key? key,
    required this.itemCount,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PickCartScreen(
              email: email,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          if (itemCount > 0)
            badges.Badge(
              badgeContent: Text(
                itemCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              badgeAnimation: const badges.BadgeAnimation.scale(),
              position: badges.BadgePosition.topEnd(end: -7, top: -17),
              showBadge: itemCount > 0 ? true : false,
              child: const Icon(Icons.shopping_cart, size: 40),
            )
          else
            const Icon(Icons.shopping_cart, size: 40),
        ],
      ),
    );
  }
}
