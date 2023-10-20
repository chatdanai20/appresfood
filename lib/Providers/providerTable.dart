import 'package:flutter_k/export.dart';

class tableProvider with ChangeNotifier {
  List<Table> table = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addTable(Table table) async {
    try {
      await firestore.collection('tables').add({
        'numberOfPeople': table.numberOfPeople,
        'orderFood': table.orderFood,
        'timestamp': table.timestamp,
      });
    } catch (error) {
      print('Error adding table to Firestore: $error');
    }
  }

  // Get MenuFood
  List<Table> getMenuFood() {
    return table;
  }

  void addMenuFood(Table statement) {
    table.add(statement);
    notifyListeners();
  }
}

class Table {
  int numberOfPeople;
  bool orderFood;
  Timestamp timestamp;
  Table({
    required this.numberOfPeople,
    required this.orderFood,
    required this.timestamp,
  });
}

void addNewTable() {
  Table newTable = Table(
    numberOfPeople: 4,
    orderFood: false,
    timestamp: Timestamp.now(),
  );

  tableProvider().addTable(newTable);
}
