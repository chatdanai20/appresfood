import 'package:flutter_k/export.dart';

class SearchScreen extends StatefulWidget {
  final String email;
  const SearchScreen({Key? key, required this.email}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  Future<void> _loadDataFromFirestore() async {
    try {
      final QuerySnapshot restaurantQuery =
          await firestoreInstance.collection('RestaurantApp').get();

      final List<Search> restaurantSearchs = restaurantQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Search(
          name: data['name'] as String? ?? '',
          image: data['image'] as String? ?? '',
          email: data['email'] as String? ?? '',
        );
      }).toList();

      final QuerySnapshot menuQuery =
          await firestoreInstance.collection('Menu').get();

      final List<Search> menuSearchs = menuQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Search(
          name: data['name'] as String? ?? '',
          image: data['image'] as String? ?? '',
          email: data['email'] as String? ?? '',
        );
      }).toList();

      final List<Search> allSearchs = [...restaurantSearchs, ...menuSearchs];

      Provider.of<searchProvider>(context, listen: false)
          .updatesearchs(allSearchs);
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
            .startAt([queryText.toUpperCase()]).endAt(
                ['${queryText.toLowerCase()}\uf8ff']).get();

        final List<Search> searchResults = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          return Search(
            name: data['name'] as String? ?? '',
            image: data['image'] as String? ?? '',
            email: data['email'] as String? ?? '',
          );
        }).toList();

        Provider.of<searchProvider>(context, listen: false)
            .updatesearchs(searchResults);
      }
    } catch (error) {
      print('เกิดข้อผิดพลาดในการค้นหา: $error');
    }
  }

  Future<void> _searchFoods() async {
    String queryText = _searchController.text.trim();
    try {
      if (queryText.isEmpty) {
        _loadDataFromFirestore();
      } else {
        final QuerySnapshot querySnapshot = await firestoreInstance
            .collection('Menu')
            .orderBy('name')
            .startAt([queryText.toUpperCase()]).endAt(
                ['${queryText.toLowerCase()}\uf8ff']).get();

        final List<Search> searchResults = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          return Search(
            name: data['name'] as String? ?? '',
            image: data['image'] as String? ?? '',
            email: data['email'] as String? ?? '',
          );
        }).toList();

        Provider.of<searchProvider>(context, listen: false)
            .updatesearchs(searchResults);
      }
    } catch (error) {
      print('เกิดข้อผิดพลาดในการค้นหา: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer(
        builder: (context, searchProvider provider, child) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                _buildSearchField(),
                const Text(
                  'ร้านอาหาร และรายการอาหารทั้งหมด',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: _buildListView(provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.redAccent,
      elevation: 5,
      title: const Text('ร้านอาหาร service customers'),
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          }),
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
            onChanged: (text) {
              _searchRestaurants();
              _searchFoods();
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              hintText: 'ค้นหาร้านอาหารหรือรายการอาหาร',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
          )),
    );
  }

  // Widget _buildGridView(searchProvider provider) {
  //   return GridView.builder(
  //     itemCount: provider.searchs.length,
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       mainAxisSpacing: 10,
  //       crossAxisSpacing: 10,
  //     ),
  //     itemBuilder: (context, int index) {
  //       Search resData = provider.searchs[index];
  //       return InkWell(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ReserveScreen(email: resData.email),
  //             ),
  //           );
  //           print(resData.email);
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(20),
  //               color: Colors.redAccent,
  //               boxShadow: const [
  //                 BoxShadow(
  //                   color: Colors.black38,
  //                   spreadRadius: 0.5,
  //                   blurRadius: 10,
  //                 ),
  //               ],
  //             ),
  //             child: Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 5),
  //                   child: Container(
  //                     height: 100,
  //                     width: 120,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(20),
  //                       image: DecorationImage(
  //                         image: NetworkImage(resData.image),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 5),
  //                 Text(
  //                   resData.name,
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildListView(searchProvider provider) {
    return ListView.builder(
      itemCount: provider.searchs.length,
      itemBuilder: (context, int index) {
        Search resData = provider.searchs[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReserveScreen(email: resData.email),
              ),
            );
            print(resData.email);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
              child: Row(
                children: [
                  if (resData.image.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        height: 100,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(resData.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      resData.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget _buildListViewFood(searchProvider provider) {
  //   return ListView.builder(
  //     itemCount: provider.searchs.length,
  //     itemBuilder: (context, int index) {
  //       Search resData = provider.searchs[index];
  //       return InkWell(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ReserveScreen(email: resData.email),
  //             ),
  //           );
  //           print(resData.email);
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(20),
  //               color: Colors.redAccent,
  //               boxShadow: const [
  //                 BoxShadow(
  //                   color: Colors.black38,
  //                   spreadRadius: 0.5,
  //                   blurRadius: 10,
  //                 ),
  //               ],
  //             ),
  //             child: Row(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(right: 15),
  //                   child: Container(
  //                     height: 100,
  //                     width: 120,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(20),
  //                       image: DecorationImage(
  //                         image: NetworkImage(resData.image),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Text(
  //                     resData.name,
  //                     style: const TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
