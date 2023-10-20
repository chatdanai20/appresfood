// import 'package:flutter_k/export.dart';

// class PromotionPage extends StatefulWidget {
//   String? _message;
//   PromotionPage({super.key});

//   @override
//   _PromotionPageState createState() => _PromotionPageState();
// }

// class _PromotionPageState extends State<PromotionPage> {
//   final _codeController = TextEditingController();
//   String _message = '';
//   double originalPrice = 500;
//   int quantity = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('โปรโมชั่น')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _codeController,
//               decoration: const InputDecoration(
//                 labelText: 'กรอกรหัสโปรโมชั่น',
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _applyPromotion,
//               child: const Text('ใช้โปรโมชั่น'),
//             ),
//             const SizedBox(height: 20),
//             Text(_message),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _applyPromotion() async {
//     final code = _codeController.text;
//     final result = await checkPromotion(code, originalPrice, quantity);
//     setState(() {
//       _message = result['message'];
//     });
//   }

//   Future<Map<String, dynamic>> checkPromotion(
//       String code, double originalPrice, int quantity) async {
//     final firestore = FirebaseFirestore.instance;
//     final promotionRef = firestore.collection('promotions').doc(code);
//     final docSnapshot = await promotionRef.get();

//     Map<String, dynamic> result = {
//       'discountedPrice': originalPrice,
//       'quantity': quantity,
//       'isValid': false,
//       'message': ''
//     };

//     if (!docSnapshot.exists) {
//       result['message'] = 'โค้ดไม่ถูกต้อง';
//       return result;
//     }

//     final data = docSnapshot.data();
//     final expirationDate = (data!['expirationDate'] as Timestamp).toDate();
//     if (DateTime.now().isAfter(expirationDate)) {
//       result['message'] = 'โค้ดหมดอายุ';
//       return result;
//     }

//     final discountType = data['discountType'];

//     switch (discountType) {
//       case 'PERCENT':
//         final discountValue = data['discountValue'];
//         result['discountedPrice'] =
//             originalPrice - (originalPrice * discountValue / 100);
//         result['isValid'] = true;
//         result['message'] = 'ลดราคา $discountValue%';
//         break;
//       case 'AMOUNT':
//         final discountValue = data['discountValue'];
//         result['discountedPrice'] = originalPrice - discountValue;
//         result['isValid'] = true;
//         result['message'] = 'ลดราคา $discountValue บาท';
//         break;
//       case 'BUY_ONE_GET_ONE':
//         result['quantity'] = quantity * 2;
//         result['isValid'] = true;
//         result['message'] = 'โปรโมชั่น 1 แถม 1';
//         break;
//       default:
//         result['message'] = 'โค้ดไม่ถูกต้อง';
//         break;
//     }

//     return result;
//   }
// }

// enum PaymentMethod { cash, credit }

// class PaymentMethodCard extends StatefulWidget {
//   const PaymentMethodCard({Key? key}) : super(key: key);

//   @override
//   State<PaymentMethodCard> createState() => _PaymentMethodCardState();
// }

// class _PaymentMethodCardState extends State<PaymentMethodCard> {
//   PaymentMethod _paymentMethod = PaymentMethod.cash;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         side: const BorderSide(color: Colors.grey, width: 0.4),
//         borderRadius: BorderRadius.circular(4.0),
//       ),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('เลือกวิธีการชำระเงิน',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: RadioListTile<PaymentMethod>(
//                     title: const Text('เงินสด'),
//                     value: PaymentMethod.cash,
//                     groupValue: _paymentMethod,
//                     activeColor: Colors.redAccent,
//                     onChanged: (PaymentMethod? value) {
//                       setState(() {
//                         _paymentMethod = value!;
//                       });
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: RadioListTile<PaymentMethod>(
//                     title: const Text('บัตรเครดิต'),
//                     value: PaymentMethod.credit,
//                     groupValue: _paymentMethod,
//                     activeColor: Colors.redAccent,
//                     onChanged: (PaymentMethod? value) {
//                       setState(() {
//                         _paymentMethod = value!;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
