import 'package:flutter_k/export.dart';

class PaymentScreen extends StatelessWidget {
  final List<Cart> cartItems;

  const PaymentScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('ชำระเงิน'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FoodCard(cartItems: cartItems),
              const DiscountCard(),
              const PaymentMethodCard(),
              TotalPaymentCard(cartItems: cartItems),
              Container(
                width: double.infinity,
                height: 70,
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Navigate or perform other actions
                  },
                  child: const Text(
                    'ยืนยันการชำระเงิน',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final List<Cart> cartItems;

  const FoodCard({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 0.7),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text('รายการอาหาร',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...cartItems.map((cartItem) => ListTile(
                  title: Text(cartItem.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(cartItem.option,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  trailing: Text('฿ ${cartItem.price}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ))
          ],
        ),
      ),
    );
  }
}

class DiscountCard extends StatefulWidget {
  const DiscountCard({Key? key}) : super(key: key);

  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  final TextEditingController _codecontroller = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _applyPromotion() async {
    final code = _codeController.text;
    final result = await checkPromotion(code, originalPrice, quantity);
    setState(() {
      _message = result['message'];
    });
  }

  Future<Map<String, dynamic>> checkPromotion(
      String code, double originalPrice, int quantity) async {
    final firestore = FirebaseFirestore.instance;
    final promotionRef = firestore.collection('promotions').doc(code);
    final docSnapshot = await promotionRef.get();

    Map<String, dynamic> result = {
      'discountedPrice': originalPrice,
      'quantity': quantity,
      'isValid': false,
      'message': ''
    };

    if (!docSnapshot.exists) {
      result['message'] = 'โค้ดไม่ถูกต้อง';
      return result;
    }

    final data = docSnapshot.data();
    final expirationDate = (data!['expirationDate'] as Timestamp).toDate();
    if (DateTime.now().isAfter(expirationDate)) {
      result['message'] = 'โค้ดหมดอายุ';
      return result;
    }

    final discountType = data['discountType'];

    switch (discountType) {
      case 'PERCENT':
        final discountValue = data['discountValue'];
        result['discountedPrice'] =
            originalPrice - (originalPrice * discountValue / 100);
        result['isValid'] = true;
        result['message'] = 'ลดราคา $discountValue%';
        break;
      case 'AMOUNT':
        final discountValue = data['discountValue'];
        result['discountedPrice'] = originalPrice - discountValue;
        result['isValid'] = true;
        result['message'] = 'ลดราคา $discountValue บาท';
        break;
      case 'BUY_ONE_GET_ONE':
        result['quantity'] = quantity * 2;
        result['isValid'] = true;
        result['message'] = 'โปรโมชั่น 1 แถม 1';
        break;
      default:
        result['message'] = 'โค้ดไม่ถูกต้อง';
        break;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 0.4),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('กรอกรหัสส่วนลด',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        controller: _codeController,
                        decoration: const InputDecoration(
                          labelText: 'รหัสส่วนลด',
                          border: OutlineInputBorder(),
                          // Remove errorText from here
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(height: 50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: _applyPromotion,
                    child: const Text('ใช้งาน'),
                  ),
                ),
              ],
            ),
            // Add error message here
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 5),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: _errorMessage == 'โค้ดส่วนลดถูกต้อง'
                        ? Colors.green
                        : Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum PaymentMethod { cash, credit }

class PaymentMethodCard extends StatefulWidget {
  const PaymentMethodCard({Key? key}) : super(key: key);

  @override
  State<PaymentMethodCard> createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<PaymentMethodCard> {
  PaymentMethod _paymentMethod = PaymentMethod.cash;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 0.4),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('เลือกวิธีการชำระเงิน',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: RadioListTile<PaymentMethod>(
                    title: const Text('เงินสด'),
                    value: PaymentMethod.cash,
                    groupValue: _paymentMethod,
                    activeColor: Colors.redAccent,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<PaymentMethod>(
                    title: const Text('บัตรเครดิต'),
                    value: PaymentMethod.credit,
                    groupValue: _paymentMethod,
                    activeColor: Colors.redAccent,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TotalPaymentCard extends StatelessWidget {
  final List<Cart> cartItems;

  const TotalPaymentCard({Key? key, required this.cartItems}) : super(key: key);

  int calculateTotalPrice() {
    return cartItems.fold(
        0, (total, cart) => total + (cart.price * cart.quantity).toInt());
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = calculateTotalPrice();
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 0.4),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('สรุปการชำระเงิน',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ราคา',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('฿ $totalPrice',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ส่วนลด',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('฿ 0',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('รายจ่ายทั้งหมด',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('฿ $totalPrice',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
