// ignore_for_file: unused_local_variable
import 'package:flutter_k/export.dart';
import 'package:intl/intl.dart';

class ReserveScreen extends StatefulWidget {
  final String email;
  const ReserveScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  late int numberOfPeople;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    numberOfPeople = 0;
    widget.email;
    fetchTimeSlots();
    Firebase.initializeApp();
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.redAccent,
            colorScheme: const ColorScheme.light(primary: Colors.redAccent),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  List<Map<String, dynamic>> timeSlots = [];
  String? selectedTimeSlot;

  Widget buildDateTimePicker() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent,
              onPrimary: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
                selectedDate == null
                    ? "เลือกวันที่ต้องการจอง"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                style: const TextStyle(fontSize: 20)),
            onPressed: () => _selectDate(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> fetchTimeSlots() async {
    final restaurantRef = FirebaseFirestore.instance.collection('restaurant');
    final snapshot =
        await restaurantRef.where('email', isEqualTo: widget.email).get();

    if (snapshot.docs.isNotEmpty) {
      final restaurant = snapshot.docs.first;
      final slots = restaurant.data()['timeSlots'];
      if (slots != null) {
        setState(() {
          timeSlots = List<Map<String, dynamic>>.from(slots);
        });
      }
    }
  }

  Widget _buildTimePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedTimeSlot,
            hint: const Text('เลือกช่วงเวลา'),
            onChanged: (String? newValue) {
              setState(() {
                selectedTimeSlot = newValue!;
              });
            },
            items: timeSlots.map<DropdownMenuItem<String>>((slot) {
              final time = slot['timeSlot'] as String;
              return DropdownMenuItem<String>(
                value: time,
                child: Text(time),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> showOrderConfirmationDialog(BuildContext context) async {
    final thailandDateTime = DateTime.now().add(const Duration(hours: 0));
    final formattedDateTime =
        DateFormat.yMd('th').add_Hm().format(thailandDateTime);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('สั่งอาหารเพิ่ม?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('คุณต้องการสั่งอาหารเพิ่มหรือไม่?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ปิด'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('สั่งอาหารเพิ่ม'),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MenuScreen(
                      email: widget.email,
                      numberOfPeople: numberOfPeople,
                      cartItems: const [],
                      isEdit: false,
                      selectedDate: selectedDate,
                      selectedTimeSlot: selectedTimeSlot,
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  void decreaseNumberOfPeople() {
    setState(() {
      if (numberOfPeople > 0) {
        numberOfPeople--;
        textEditingController.text = numberOfPeople.toString();
      }
    });
  }

  void increaseNumberOfPeople() {
    setState(() {
      numberOfPeople++;
      textEditingController.text = numberOfPeople.toString();
    });
  }

  void confirmReservation(BuildContext context) async {
    if (numberOfPeople > 0) {
      await showOrderConfirmationDialog(context);
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('กรุณากรอกจำนวนคน'),
            content: const Text('กรุณากรอกจำนวนคนก่อนที่จะยืนยัน'),
            actions: <Widget>[
              TextButton(
                child: const Text('ตกลง'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget buildNumberOfPeopleInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: decreaseNumberOfPeople,
              child: Container(
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
                child: const Icon(
                  Icons.remove,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    numberOfPeople = int.tryParse(value) ?? 0;
                  },
                  decoration: const InputDecoration(
                    hintText: 'กรอกจำนวนคน',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: increaseNumberOfPeople,
              child: Container(
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
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const Text(
          '*4 ท่าน/โต๊ะ',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ],
    );
  }

  Widget buildReservationButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.redAccent),
          child: const Text(
            "ยืนยัน",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          onPressed: () {
            confirmReservation(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 5,
        title: const Text('จองที่นั่ง'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Provider.of<CartProvider>(context, listen: false).clearCart();
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "กรุณาเลือกวันและเวลาที่ต้องการจอง",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            buildDateTimePicker(),
            const Text(
              "กรุณาเลือกช่วงเวลาที่ต้องการจอง",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildTimePicker(),
            const SizedBox(height: 20),
            const Text(
              "กรุณากรอกจำนวนคน",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            buildNumberOfPeopleInput(),
            const SizedBox(height: 20),
            buildReservationButton(context),
          ],
        ),
      ),
    );
  }
}
