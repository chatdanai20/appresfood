// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable
import 'package:flutter_k/Screens/Pick_it/search/picksearch.dart';
import 'package:flutter_k/export.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  final _searchController = TextEditingController();
  late FirebaseMessaging messaging;
  void setup() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      // print("Push token: $value");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('message recieved');
      print(message.notification!.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('รับข้อความจากร้านค้า'),
            content: Text(message.notification!.body!),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('ปิด'))
            ],
          );
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    setup();
    _loadDataFromFirestore();
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchScreen(
              email: '',
            ),
          ),
        );
      }
    });
  }

  Future<void> _loadDataFromFirestore() async {
    try {
      final QuerySnapshot querySnapshot =
          await firestoreInstance.collection('RestaurantApp').get();

      final List<Search> searches = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Search(
          name: data['name'] as String? ?? '',
          image: data['image'] as String? ?? '',
          email: data['email'] as String? ?? '',
        );
      }).toList();

      if (mounted) {
        Provider.of<searchProvider>(context, listen: false)
            .updatesearchs(searches);
      }
    } catch (error) {
      print('เกิดข้อผิดพลาดในการโหลดข้อมูล: $error');
    }
  }

  Future<void> _searchRestaurants() async {
    String queryText = _searchController.text.trim();
    try {
      if (queryText.isEmpty) {
        _loadDataFromFirestore();
      } else {
        final QuerySnapshot querySnapshot = await firestoreInstance
            .collection('RestaurantApp')
            .orderBy('name')
            .startAt([queryText.toUpperCase(), queryText.toLowerCase()]).endAt([
          '${queryText.toLowerCase()}\uf8ff',
          '${queryText.toUpperCase()}\uf8ff'
        ]).get();

        final List<Search> searchResults = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          return Search(
            name: data['name'] as String? ?? '',
            image: data['image'] as String? ?? '',
            email: data['email'] as String? ?? '',
          );
        }).toList();

        if (mounted) {
          Provider.of<searchProvider>(context, listen: false)
              .updatesearchs(searchResults);
        }
      }
    } catch (error) {
      print('เกิดข้อผิดพลาดในการค้นหา: $error');
    }
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
                _buildTitle(),
                const SizedBox(height: 20),
                _buildSearchField(),
                const SizedBox(height: 5),
                _buildServiceButtons(context),
                const SizedBox(height: 5),
                _buildRecommendedRestaurants(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return const Center(
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
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            hintText: 'ค้นหาร้านอาหาร',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(
                  email: '',
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildServiceButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(
                  email: '',
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PickSearchScreen(
                  email: '',
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 40),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: _buildRecommendedRestaurantsTitle(),
        ),
        const SizedBox(height: 10),
        _buildRecommendedRestaurantsGrid(),
      ],
    );
  }
}

Widget _buildRecommendedRestaurantsTitle() {
  return Row(
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const SearchScreen(),
          //   ),
          // );
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
  );
}

Widget _buildRecommendedRestaurantsGrid() {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: FutureBuilder<List<dynamic>>(
      future: Future.wait([
        FirebaseFirestore.instance.collection("RestaurantApp").get(),
        FirebaseFirestore.instance.collection("restaurant").get(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> restaurantAppDocs =
              snapshot.data![0].docs;
          List<QueryDocumentSnapshot> restaurantDocs = snapshot.data![1].docs;

          // Create a map for easier lookup of restaurantAppDocs by email
          Map<String, QueryDocumentSnapshot> restaurantAppDocsByEmail = {
            for (var doc in restaurantAppDocs) doc['email']: doc
          };

          // Filter and map restaurantDocs by checking if they exist in restaurantAppDocsByEmail
          var validRestaurants = restaurantDocs
              .where(
                (restaurant) =>
                    restaurantAppDocsByEmail.containsKey(restaurant['email']),
              )
              .map(
                (restaurant) => {
                  'restaurantApp':
                      restaurantAppDocsByEmail[restaurant['email']]!,
                  'restaurant': restaurant
                },
              )
              .toList();

          return GridView.builder(
            itemCount: validRestaurants.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, int index) {
              var restaurantAppData = validRestaurants[index]['restaurantApp'];
              var restaurantData = validRestaurants[index]['restaurant'];

              String restaurantName =
                  restaurantAppData?['name'] ?? 'Default Name';
              String email = restaurantData?['email'] ?? 'No Email';
              String image = restaurantAppData?['image'] ?? 'Default Image URL';

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReserveScreen(email: email),
                    ),
                  );
                  print(restaurantName);
                  print(email);
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 100,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          restaurantName.toUpperCase() ?? 'No Name',
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
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}
