import 'package:flutter_k/export.dart';

class PaymentProvider extends ChangeNotifier {
  double? discountedPrice;
  String? discountMessage;

  void applyPromotion(String code, double originalPrice, int quantity) async {
    final discount = await FirebaseFirestore.instance
        .collection('Promotion')
        .doc(code)
        .get();
    notifyListeners();
  }
}
