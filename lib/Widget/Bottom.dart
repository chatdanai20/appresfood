// ignore_for_file: must_be_immutable

import 'package:flutter_k/export.dart';

class Bottom extends StatefulWidget {
  String name;
  int size;
  final Function()? onTap;
  bool isLoggedIn;
  Bottom({
    Key? key,
    required this.name,
    required this.size,
    this.onTap,
    this.isLoggedIn = false,
  }) : super(key: key);

  @override
  _BottomState createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  final TextStyle _textStyle = const TextStyle(
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            widget.name,
            style: _textStyle.copyWith(
              color: widget.isLoggedIn ? Colors.blue : Colors.white,
              fontSize: widget.size.toDouble(),
            ),
          ),
        ),
      ),
    );
  }
}
