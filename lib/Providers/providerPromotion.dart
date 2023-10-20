import 'package:flutter_k/export.dart';

class promotionProvider with ChangeNotifier {
  //List Promotion
  List<Promotions> promotions = [
    Promotions(namePro: "โปรโมชั่น 1", description: "ส่วนลด 10%"),
    Promotions(namePro: "โปรโมชั่น 2", description: "ส่วนลด 20%"),
    Promotions(namePro: "โปรโมชั่น 3", description: "ส่วนลด 30%"),
    Promotions(namePro: "โปรโมชั่น 4", description: "ส่วนลด 40%"),
    Promotions(namePro: "โปรโมชั่น 5", description: "1 แถม 1"),
    Promotions(namePro: "โปรโมชั่น 6", description: "2 แถม 1"),
    Promotions(namePro: "โปรโมชั่น 7", description: "3 แถม 1"),
  ];

  // get Promotion
  List<Promotions> getPromotion() {
    return promotions;
  }

  void addPromotion(Promotions statemant) {
    promotions.add(statemant);
    notifyListeners();
  }
}
