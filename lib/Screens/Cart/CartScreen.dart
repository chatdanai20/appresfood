// ignore_for_file: unused_local_variable

import 'package:flutter_k/export.dart';

class CartScreen extends StatefulWidget {
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final int numberOfPeople;
  final String email;

  const CartScreen({
    Key? key,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.numberOfPeople,
    required this.email,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late String email;
  late int numberOfPeople;
  late DateTime? selectedDate;
  late String? selectedTimeSlot;
  late int day;
  late int month;
  late int year;
  @override
  void initState() {
    super.initState();
    email = widget.email;
    numberOfPeople = widget.numberOfPeople;
    selectedDate = widget.selectedDate;
    selectedTimeSlot = widget.selectedTimeSlot;
  }

  Future<List<Map<String, dynamic>>> fetchExtras() async {
    try {
      CollectionReference menu = FirebaseFirestore.instance.collection('Menu');
      QuerySnapshot menuSnapshot = await menu.get();

      List<Map<String, dynamic>> extrasList = [];
      for (var document in menuSnapshot.docs) {
        extrasList.add(document.data() as Map<String, dynamic>);
      }
      return extrasList;
    } catch (e) {
      print('Error fetching extras: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer(
        builder: (context, CartProvider provider, child) {
          return SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: ListView.builder(
                itemCount: provider.carts.length,
                itemBuilder: (BuildContext context, int index) {
                  Cart cartData = provider.carts[index];
                  return _buildCartItem(cartData, provider);
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, provider, child) {
          double totalPrice = provider.getTotalPrice();
          return _buildBottomAppBar(totalPrice, provider);
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.redAccent,
      title: const Text('รายการที่เลือก'),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildCartItem(Cart cartData, CartProvider provider) {
    List<String> selectedExtrasWithPrices =
        cartData.selectedOption.asMap().entries.map((entry) {
      int idx = entry.key;
      String extraName = entry.value;

      return '$extraName ';
    }).toList();

    double itemTotalPrice = cartData.price.toDouble() + cartData.priceExtra;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              height: 120,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(cartData.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cartData.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        provider.removeCartItem(cartData);
                      },
                      icon: const Icon(Icons.delete,
                          color: Colors.black, size: 30),
                    ),
                  ],
                ),
                Text(
                  "ประเภท : ${cartData.option.isEmpty ? '' : cartData.option}",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  selectedExtrasWithPrices.join(', '),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                _buildRemark(cartData),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$itemTotalPrice บาท',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              _buildIncrementButton(provider, cartData),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '${cartData.quantity}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              _buildDecrementButton(provider, cartData),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncrementButton(CartProvider provider, Cart cartData) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          provider.incrementCartItem(cartData);
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 18,
        ),
      ),
    );
  }

  Widget buildExtrasWidget() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchExtras(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data found');
        } else {
          List<Map<String, dynamic>> extrasList = snapshot.data!;
          return ListView.builder(
            itemCount: extrasList.length,
            itemBuilder: (context, index) {
              final extra = extrasList[index];
              final String extraName = extra['name'] ?? '';
              final double extraPrice = (extra['price'] ?? 0).toDouble();
              return ListTile(
                title: Text('$extraName - $extraPrice'),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildDecrementButton(CartProvider provider, Cart cartData) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (cartData.quantity > 1) {
            provider.decrementCartItem(cartData);
          }
        },
        child: const Icon(
          Icons.remove,
          color: Colors.black,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildRemark(Cart cartData) {
    return Text(
      'หมายเหตุ: ${cartData.remark ?? ''}',
      style: const TextStyle(
        fontSize: 18,
        color: Colors.yellowAccent,
      ),
    );
  }

  BottomAppBar _buildBottomAppBar(double totalPrice, CartProvider provider) {
    return BottomAppBar(
      color: Colors.redAccent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ค่าใช้จ่ายทั้งหมด',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${totalPrice.toStringAsFixed(2)} บาท',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            _buildPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              cartItems:
                  Provider.of<CartProvider>(context, listen: false).carts,
              email: email,
              numberOfPeople: numberOfPeople,
              selectedDate: widget.selectedDate,
              selectedTimeSlot: widget.selectedTimeSlot,
            ),
          ),
        );
        print(numberOfPeople);
      },
      child: const Text(
        'ชําระเงิน',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
