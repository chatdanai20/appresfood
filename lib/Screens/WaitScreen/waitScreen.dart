import 'package:flutter_k/Screens/Listorders/ListOrderScreen.dart';
import 'package:flutter_k/export.dart';

class WaitScreen extends StatefulWidget {
  const WaitScreen({
    Key? key,
  }) : super(key: key);

  @override
  _WaitScreenState createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  late final CollectionReference _waitingCollection;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    print(_user?.email);
    _waitingCollection = FirebaseFirestore.instance.collection('Waiting');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รอการยืนยัน'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: (_user != null)
            ? StreamBuilder(
                stream: _waitingCollection
                    .where('user', isEqualTo: _user?.email)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('เกิดข้อผิดพลาด');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data!.docs.isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListmenuScreen(),
                          ),
                        );
                      });
                      return const Text('ไม่มีรายการที่รอยืนยัน');
                    }
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            color: Colors.redAccent,
                            strokeWidth: 10,
                            strokeCap: StrokeCap.round,
                            key: Key('รอการยืนยัน'),
                          ),
                        ),
                        const SizedBox(height: 60),
                        const Text(
                          'รอการยืนยัน',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _confirmCancel(context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                              ),
                              child: const Text(
                                'ยกเลิก',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const Text('ไม่ได้เข้าสู่ระบบ'),
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการยกเลิก'),
          content: const Text('คุณต้องการยกเลิกการรอยืนยันหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('ไม่', style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () {
                _cancelWaiting();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const AuthHome();
                    },
                  ),
                );
              },
              child:
                  const Text('ใช่', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  void _cancelWaiting() async {
    if (_user?.email != null) {
      QuerySnapshot querySnapshot =
          await _waitingCollection.where('user', isEqualTo: _user?.email).get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await _waitingCollection.doc(doc.id).delete();
      }
    }
  }
}
