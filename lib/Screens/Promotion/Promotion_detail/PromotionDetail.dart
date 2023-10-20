import 'package:flutter_k/export.dart';

class PromotionDetail extends StatelessWidget {
  final String description;
  final String name;
  final String id;
  final String discountType;
  final int discountValue;

  const PromotionDetail({
    super.key,
    required this.description,
    required this.name,
    required this.id,
    required this.discountType,
    required this.discountValue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'โปรโมชั่น',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ชื่อ: $name',
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'รายละเอียดโปรโมชั่น: $description',
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'code ส่วนลด: $id',
              style: const TextStyle(
                fontSize: 26,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'ประเภทส่วนลด: $discountType',
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'มูลค่าส่วนลด: $discountValue',
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
