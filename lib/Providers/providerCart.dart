import 'package:flutter_k/export.dart';

class CartProvider with ChangeNotifier {
  List<Cart> carts = [];
  final List<Cart> _cartItems = [];
  List<Cart> get cartItems => _cartItems;

  bool isItemExistInCart(Cart newItem, List<Cart> currentCarts) {
    for (var existingItem in currentCarts) {
      if (existingItem.name == newItem.name &&
          existingItem.option == newItem.option &&
          areSelectedExtrasSame(
              existingItem.selectedOption, newItem.selectedOption) &&
          arePricesSame(existingItem.selectedExtrasPrices,
              newItem.selectedExtrasPrices)) {
        return true;
      }
    }
    return false;
  }

  bool areSelectedExtrasSame(
      List<String> existingExtras, List<String> newExtras) {
    if (existingExtras.length != newExtras.length) return false;
    for (int i = 0; i < existingExtras.length; i++) {
      if (existingExtras[i] != newExtras[i]) return false;
    }
    return true;
  }

  bool arePricesSame(List<String> existingPrices, List<String> newPrices) {
    if (existingPrices.length != newPrices.length) return false;
    for (int i = 0; i < existingPrices.length; i++) {
      if (existingPrices[i] != newPrices[i]) return false;
    }
    return true;
  }

  void addCartItem(Cart newItem) {
    if (isItemExistInCart(newItem, carts)) {
      print('Item already exists in the cart');
    } else {
      carts.add(newItem);
    }
    notifyListeners();
  }

  void removeCartItem(Cart cartItem) {
    carts.remove(cartItem);
    notifyListeners();
  }

  void incrementCartItem(Cart cartItem) {
    cartItem.quantity++;
    notifyListeners();
  }

  void decrementCartItem(Cart cartData) {
    if (cartData.quantity > 1) {
      cartData.quantity -= 1;
      notifyListeners(); // to update UI
    }
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    for (var cartItem in carts) {
      totalPrice += (cartItem.price.toDouble()) * cartItem.quantity;
    }
    return totalPrice;
  }

  void clearCart() {
    carts.clear();
    notifyListeners();
  }
}
