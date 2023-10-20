import 'package:flutter_k/export.dart';

class searchProvider with ChangeNotifier {
  List<Search> searchs = [];

  // get search
  List<Search> getsearch() {
    return searchs;
  }

  void addsearch(Search statement) {
    searchs.add(statement);
    notifyListeners();
  }

  void updatesearchs(List<Search> searchList) {
    searchs = searchList;
    notifyListeners();
  }

  Future<void> loadDataFromFirestore() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("RestaurantApp").get();

      final List<Search> searchList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Search(
          name: data['name'] as String? ?? '',
          image: data['image'] as String? ?? '',
          email: data['email'] as String? ?? '',
        );
      }).toList();

      updatesearchs(searchList);
    } catch (error) {
      print('เกิดข้อผิดพลาดในการโหลดข้อมูล: $error');
    }
  }
}
