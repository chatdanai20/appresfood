import 'package:flutter_k/Screens/Editmenu/Editmenu.dart';
import 'package:flutter_k/Screens/mapScreen/Mapnavigate.dart';
import 'package:flutter_k/Screens/review/reviewscreen.dart';
import 'package:flutter_k/export.dart';

class ListmenuScreen extends StatefulWidget {
  const ListmenuScreen({Key? key}) : super(key: key);

  @override
  _ListmenuScreenState createState() => _ListmenuScreenState();
}

class _ListmenuScreenState extends State<ListmenuScreen> {
  final _user = FirebaseAuth.instance.currentUser;
  bool _isAnyOrderReady = false;

  void _updateIsAnyOrderReady(bool isReady) {
    if (_isAnyOrderReady != isReady) {
      setState(() {
        _isAnyOrderReady = isReady;
      });
    }
  }

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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthHome(),
                ));
          },
          icon: const Icon(Icons.home),
        ),
        actions: _isAnyOrderReady
            ? []
            : [
                IconButton(
                  onPressed: () {
                    String email = _user?.email ?? '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapNavigate(email: email),
                      ),
                    );
                    print(email);
                  },
                  icon: const Icon(Icons.map),
                ),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('order')
                  .where('user', isEqualTo: _user?.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // if (snapshot.data!.docs.isEmpty) {
                //   Future.microtask(() {
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const ReviewPage(),
                //       ),
                //     );
                //   });

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var orderData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;

                      try {
                        int numberOfPeople =
                            int.parse(orderData['number_of_people'].toString());
                        double totalPrice =
                            double.parse(orderData['total_price'].toString());
                        double finalPrice =
                            double.parse(orderData['final_price'].toString());
                        double discount =
                            double.parse(orderData['discount'].toString());
                        List<dynamic> items = orderData['items'];
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(Icons.fastfood,
                                            color: Colors.redAccent),
                                        Text(
                                          'User: $user',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent),
                                        ),
                                        Text(
                                          ' $status',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                    ...items.map((item) {
                                      var itemMap =
                                          Map<String, dynamic>.from(item);
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${itemMap['name']} x ${itemMap['quantity']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              '${itemMap['price']} \$',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    const SizedBox(height: 8),
                                    Text(
                                      'จำนวนคน: $numberOfPeople',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'ราคารวม: ${totalPrice.toStringAsFixed(2)} บาท',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'ส่วนลด: ${discount.toStringAsFixed(2)} บาท',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'ราคาสุทธิ: ${finalPrice.toStringAsFixed(2)} บาท',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  var action = _getButtonAction(status, user,
                                      orderData, email, items, numberOfPeople);
                                  if (action != null) {
                                    action();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _getButtonColor(status),
                                ),
                                child: Text(
                                  _getButtonText(status),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } catch (e) {
                        return const Text('เกิดข้อผิดพลาด');
                      }
                    },
                  ),
                );
                // }
                return const Center(
                  child: Text('ไม่มีรายการอาหาร'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Function? _getButtonAction(
      String status,
      String user,
      Map<String, dynamic> orderData,
      String email,
      List<dynamic> items,
      int numberOfPeople) {
    if (status == 'ยืนยันแล้ว') {
      return () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EditMenuScreen(
                user: user,
                orderData: orderData,
                email: email,
                cartItems: items,
                numberOfPeople: numberOfPeople,
              );
            },
          ),
        );
      };
    } else if (status == 'ทำอาหารเสร็จแล้ว') {
      return () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapNavigate(email: email),
          ),
        );
        print(email);
      };
    }
    return null;
  }

  Color _getButtonColor(String status) {
    if (status == 'กำลังทำอาหาร') {
      return Colors.grey;
    }
    return Colors.redAccent;
  }

  String _getButtonText(String status) {
    if (status == 'ยืนยันแล้ว' || status == 'กำลังทำอาหาร') {
      return 'แก้ไข';
    } else if (status == 'ทำอาหารเสร็จแล้ว') {
      return 'แผนที่';
    }
    return 'แก้ไข';
  }
}
