import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_k/Screens/review/reviewscreen.dart';

class PickListmenuScreen extends StatefulWidget {
  const PickListmenuScreen({Key? key}) : super(key: key);

  @override
  _PickListmenuScreenState createState() => _PickListmenuScreenState();
}

class _PickListmenuScreenState extends State<PickListmenuScreen> {
  final _user = FirebaseAuth.instance.currentUser;
  final bool _isAnyOrderReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการอาหาร'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.refresh),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('PickHome')
                  .where('user', isEqualTo: _user?.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('เกิดข้อผิดพลาด'));
                }

                if (snapshot.data!.docs.isEmpty) {
                  Future.microtask(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReviewPage(),
                      ),
                    );
                  });
                  return const Center(child: Text('ไม่มีรายการอาหาร'));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var orderData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return OrderCard(orderData: orderData);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;
  const OrderCard({Key? key, required this.orderData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      double totalPrice =
          double.parse(orderData['total_price'].toString() ?? '0');
      double finalPrice =
          double.parse(orderData['final_price'].toString() ?? '0');
      double discount = double.parse(orderData['discount'].toString() ?? '0');
      List<dynamic> items = orderData['items'] ?? [];
      String user = orderData['user'];
      String status = orderData['status'];
      String email = orderData['email'];

      return Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.fastfood, color: Colors.redAccent),
                      Text('User: $user',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent)),
                      Text(' $status',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent)),
                    ],
                  ),
                  ...items.map((item) {
                    var itemMap = Map<String, dynamic>.from(item);
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${itemMap['name']} x ${itemMap['quantity']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('${itemMap['price']} \$',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.green)),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                  Text('ราคารวม: ${totalPrice.toStringAsFixed(2)} บาท',
                      style: const TextStyle(fontSize: 16)),
                  Text('ส่วนลด: ${discount.toStringAsFixed(2)} บาท',
                      style: const TextStyle(fontSize: 16)),
                  Text('ราคาสุทธิ: ${finalPrice.toStringAsFixed(2)} บาท',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      return const Text('เกิดข้อผิดพลาด');
    }
  }
}
