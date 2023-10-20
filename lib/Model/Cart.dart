class Cart {
  final String name;
  int quantity;
  final String image;
  final double price;
  final String option;
  final String nameExtra;
  final double priceExtra;
  final List<String> selectedOption;
  final List<String> selectedExtrasPrices;
  final String? remark;

  Cart({
    required this.image,
    required this.name,
    required this.quantity,
    required this.price,
    required this.option,
    required this.nameExtra,
    required this.priceExtra,
    required this.selectedOption,
    required this.selectedExtrasPrices,
    required this.remark,
  });
}
