import 'package:flutter_k/export.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String email = '';
  List<String> imgList = [
    "reserve",
    "get_it_yourself",
  ];

  List<String> nameList = [
    "รับประทานที่ร้าน",
    "ไปรับที่ร้าน",
  ];

  User? currentUser;

  @override
  void initState() {
    super.initState();

    currentUser = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE7E2),
      body: Consumer(
        builder: (context, searchProvider, child) {
          return SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 50),
                const Center(
                  child: Text(
                    'Restaurant Service Customers',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSearchField(),
                const SizedBox(height: 5),
                _buildServiceButtons(),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "ร้านอาหารแนะนำ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (currentUser == null) {
                            showLoginDialog();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SearchScreen(email: email),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "เพิ่มเติม",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildRecommendedRestaurants(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            hintText: 'ค้นหาร้านอาหาร',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildServiceButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (currentUser == null) {
              showLoginDialog();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(email: email),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 35,
                horizontal: 24,
              ),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFF6E6D),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 0.5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/images/reserve.png",
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'รับประทานที่ร้าน',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (currentUser == null) {
              showLoginDialog();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(email: email),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 35,
                horizontal: 40,
              ),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFF6E6D),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 0.5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/images/get_it_yourself.png",
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'รับเองที่ร้าน',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedRestaurants() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('RestaurantApp').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            return GridView.builder(
              itemCount: documents.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, int index) {
                var data = documents[index].data() as Map<String, dynamic>;
                return InkWell(
                  onTap: () {
                    if (currentUser == null) {
                      showLoginDialog();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReserveScreen(email: email),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.redAccent,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 0.5,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(data['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            data['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          // const Padding(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 50,
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Icon(
                          //         Icons.star_rate,
                          //         color: Colors.yellowAccent,
                          //       ),
                          //       SizedBox(width: 5),
                          //       Text(
                          //         data['rate'],
                          //         style: const TextStyle(
                          //           fontSize: 16,
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        color: Color(0xFFFF6E6D),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Bottom(
                onTap: () {
                  Navigator.pushNamed(context, AppRoute.register);
                },
                name: 'sign up',
                size: 20,
              ),
            ),
            Expanded(
              child: Bottom(
                onTap: () {
                  Navigator.pushNamed(context, AppRoute.login);
                },
                name: 'Login',
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show login dialog
  void showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('กรุณาเข้าสู่ระบบ'),
          content: const Text('กรุณาเข้าสู่ระบบเพื่อดำเนินการต่อ'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ปิด'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.login);
              },
              child: const Text('เข้าสู่ระบบ'),
            ),
          ],
        );
      },
    );
  }
}
