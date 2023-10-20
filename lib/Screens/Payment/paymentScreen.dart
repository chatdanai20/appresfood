// ignore_for_file: use_build_context_synchronously

import 'package:flutter_k/export.dart';

class PaymentScreen extends StatefulWidget {
  final List<Cart> cartItems;
  final String email;
  final DateTime? selectedDate;

  final String? selectedTimeSlot;
  final int numberOfPeople;

  const PaymentScreen({
    Key? key,
    required this.cartItems,
    required this.email,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.numberOfPeople,
  }) : super(key: key);
  void onApplyPromotion() {}

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _message;
  final _codeController = TextEditingController();
  double? discountedPrice;
  String? discountMessage;

  String? user = FirebaseAuth.instance.currentUser!.email.toString();

  Future<void> saveData({
    required String userEmail,
    required String numberOfPeople,
    required List<Cart> cartItems,
    required double discountedPrice,
    required String selectedDate,
    required String selectedTimeSlot,
    required String numberTable,
  }) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Waiting');
    try {
      await collectionReference.add({
        'email': userEmail,
        'total_price':
            cartItems.fold(0.0, (total, current) => total + current.price),
        'items': cartItems
            .map((item) => {
                  'name': item.name,
                  'option': item.option,
                  'price': item.price,
                  'quantity': item.quantity,
                  'remark': item.remark,
                })
            .toList(),
        'discount': discountedPrice != 0
            ? cartItems.fold(0.0, (total, current) => total + current.price) -
                discountedPrice
            : 0,
        'final_price': discountedPrice,
        'number_of_people': numberOfPeople,
        'user': FirebaseAuth.instance.currentUser!.email.toString(),
        'status': 'รอการยืนยัน',
        'date': selectedDate.toString() ?? 'null',
        'time': selectedTimeSlot.toString() ?? 'null',
        'number_table': numberTable,
      });
    } catch (e) {
      print("Failed to save data: $e");
    }
  }

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
              _buildFood(),
              const SizedBox(height: 10),
              _buildTextField(),
              const SizedBox(height: 10),
              _buildTotal(),
              const SizedBox(height: 10),
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
                    _confirmPaymentAndNavigate(context);
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

  Future<void> _confirmPaymentAndNavigate(BuildContext context) async {
    int numberOfTables =
        widget.numberOfPeople ~/ 4 + (widget.numberOfPeople % 4 > 0 ? 1 : 0);
    print('จำนวนโต๊ะที่ต้องการ: $numberOfTables');
    try {
      await saveData(
        userEmail: widget.email,
        numberOfPeople: widget.numberOfPeople.toString(),
        cartItems: widget.cartItems,
        discountedPrice: discountedPrice ?? calculateTotalPrice(),
        selectedDate: widget.selectedDate.toString(),
        selectedTimeSlot: widget.selectedTimeSlot.toString(),
        numberTable: numberOfTables.toString(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WaitScreen(),
        ),
      );
    } catch (e) {
      print("Failed to navigate: $e");
      _showErrorDialog('Failed to navigate', e.toString());
    }
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  Widget _buildFood() {
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
            ...widget.cartItems.map(
              (cartItem) => ListTile(
                title: Text(cartItem.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(
                    '${cartItem.option} x ${cartItem.quantity} \n${cartItem.remark}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                trailing: Text(
                  '฿ ${cartItem.price}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotalPrice() {
    return widget.cartItems.fold(0, (total, current) => total + current.price);
  }

  Future<void> _applyPromotion() async {
    final code = _codeController.text;
    final originalPrice = calculateTotalPrice();
    final quantity = widget.cartItems.length;
    final result = await checkPromotion(
        code: code, originalPrice: originalPrice, quantity: quantity);

    if (result['isValid'] == true) {
      setState(() {
        discountedPrice = result['discountedPrice'];
        discountMessage = result['message'];
        _message = 'โค้ดส่วนลดถูกต้อง';
      });
    } else {
      setState(() {
        _message = result['message'];
      });
    }

    widget.onApplyPromotion();
  }

  Future<Map<String, dynamic>> checkPromotion({
    required String code,
    required double originalPrice,
    required int quantity,
  }) async {
    if (code.isNotEmpty) {
      final promotionRef =
          FirebaseFirestore.instance.collection('promotions').doc(code);
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
          print(discountValue);
          result['discountedPrice'] =
              originalPrice - (originalPrice * discountValue / 100);
          print(result['discountedPrice']);
          result['isValid'] = true;
          result['message'] = 'ลดราคา $discountValue%';
          print(result['message']);
          break;
        case 'AMOUNT':
          final discountValue = data['discountValue'];
          print(discountValue);
          result['discountedPrice'] = originalPrice - discountValue;
          print(result['discountedPrice']);
          result['isValid'] = true;
          result['message'] = 'ลดราคา $discountValue บาท';
          print(result['message']);
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
    } else {
      return {
        'discountedPrice': originalPrice,
        'quantity': quantity,
        'isValid': false,
        'message': 'โค้ดไม่ถูกต้อง'
      };
    }
  }

  Widget _buildTextField() {
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
                    onPressed: () {
                      _applyPromotion();
                    },
                    child: const Text('ใช้งาน'),
                  ),
                ),
              ],
            ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 5),
                child: Text(
                  _message!,
                  style: TextStyle(
                    color: _message == 'โค้ดส่วนลดถูกต้อง'
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

  Widget _buildTotal() {
    final originalTotalPrice = calculateTotalPrice();
    final displayTotalPrice = discountedPrice ?? originalTotalPrice;
    final discountAmount = originalTotalPrice - displayTotalPrice;

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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ราคา',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('฿ $originalTotalPrice',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ส่วนลด',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  '฿ $discountAmount',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('รายจ่ายทั้งหมด',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('฿ $displayTotalPrice',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
