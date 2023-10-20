// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_k/export.dart';

class menuProvider with ChangeNotifier {
  List<MenuFood> menuFoods = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> fetchMenuFood() async {
    try {
      final QuerySnapshot querySnapshot =
          await firestore.collection('menu').get();

      menuFoods = querySnapshot.docs.map((doc) {
        final extrasMap = List<Map>.from(doc['extras'] ?? [])
            .map((item) => {
                  'name': item['name'] as String,
                  'price': item['price'] as int,
                })
            .toList();
        return MenuFood(
          name: doc['name'],
          price: doc['price'],
          image: doc['image'],
          options: List<String>.from(doc['option']),
          userId: doc['userId'],
          extras: extrasMap,
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      print('Error fetching menu food: $error');
    }
  }

  // Get MenuFood
  List<MenuFood> getMenuFood() {
    return menuFoods;
  }

  void addMenuFood(MenuFood statement) {
    menuFoods.add(statement);
    notifyListeners();
  }
}

class MenuFood {
  String name;
  int price;
  String image;
  List<String> options;
  String userId;
  List<Map<String, Object>> extras;

  MenuFood({
    required this.name,
    required this.price,
    required this.image,
    required this.options,
    required this.userId,
    required this.extras,
  });
}
