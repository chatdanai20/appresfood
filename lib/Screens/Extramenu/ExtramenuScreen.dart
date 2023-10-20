// ignore_for_file: unused_field

import 'package:flutter_k/Providers/providerMenu.dart';
import 'package:flutter_k/export.dart';

class ExtraMenuSelect extends StatefulWidget {
  final MenuFood foodData;

  const ExtraMenuSelect({
    Key? key,
    required this.foodData,
  }) : super(key: key);

  @override
  State<ExtraMenuSelect> createState() => _ExtraMenuSelectState();
}

class _ExtraMenuSelectState extends State<ExtraMenuSelect> {
  int _selectedQuantity = 1;
  String? groupValue;
  String? _remark;
  final _remarksController = TextEditingController();

  late List<bool> _selectedExtras;

  void _incrementQuantity() {
    setState(() {
      _selectedQuantity++;
    });
  }

  void _decrementQuantity() {
    if (_selectedQuantity > 1) {
      setState(() {
        _selectedQuantity--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedExtras =
        List<bool>.generate(widget.foodData.extras.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('อาหาร'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFoodImage(),
                const SizedBox(height: 10),
                _buildFoodName(),
                const SizedBox(height: 10),
                _buildFoodPrice(),
                const SizedBox(height: 10),
                _buildRadioOptions(),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                _buildExtraCheckBoxes(),
                const SizedBox(height: 10),
                _buildRemarksSection(),
                const SizedBox(height: 10),
                _buildnum(),
                const SizedBox(height: 30),
                _buildAddToCartButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOptions() {
    if (widget.foodData.options.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เลือกเพิ่มเติม',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...widget.foodData.options.map((option) {
          return Row(
            children: [
              Radio(
                value: option,
                groupValue: groupValue,
                onChanged: (String? value) {
                  setState(() {
                    groupValue = value!;
                  });
                },
              ),
              Text(
                option,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildnum() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: IconButton(
            icon: const Icon(
              Icons.remove,
              size: 30,
            ),
            onPressed: () {
              _decrementQuantity();
            },
          ),
        ),
        Text('$_selectedQuantity', style: const TextStyle(fontSize: 30)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: IconButton(
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {
              _incrementQuantity();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFoodImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(widget.foodData.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildFoodName() {
    return Center(
      child: Text(
        widget.foodData.name,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFoodPrice() {
    return Center(
      child: Text(
        'ราคา ${widget.foodData.price} บาท',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildExtraCheckBoxes() {
    final extras = widget.foodData.extras;

    if (extras.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เลือกเพิ่มเติม',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...List<Widget>.generate(extras.length, (i) {
          return Row(
            children: [
              Checkbox(
                value: _selectedExtras[i],
                onChanged: (bool? value) {
                  print("Checkbox tapped: $value");
                  setState(() {
                    _selectedExtras[i] = value!;
                  });
                },
              ),
              Text(
                extras[i]['name']?.toString() ?? 'Default Name',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '+ ${extras[i]['price']} บาท',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        })
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: (widget.foodData.options.isEmpty) || groupValue != null
              ? Colors.redAccent
              : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: (widget.foodData.options.isEmpty) || groupValue != null
            ? () {
                List<String> selectedExtrasNames = [];
                List<String> selectedExtrasPrices = [];
                for (int i = 0; i < _selectedExtras.length; i++) {
                  if (_selectedExtras[i]) {
                    selectedExtrasNames
                        .add(widget.foodData.extras[i]['name'] as String);
                    selectedExtrasPrices
                        .add(widget.foodData.extras[i]['price'] as String);
                  }
                }

                Cart cartData = Cart(
                  name: widget.foodData.name,
                  image: widget.foodData.image,
                  price: widget.foodData.price +
                      selectedExtrasPrices.fold(0, (a, b) => a + int.parse(b)),
                  option: groupValue ?? '',
                  quantity: _selectedQuantity,
                  selectedOption: selectedExtrasNames,
                  nameExtra: '',
                  priceExtra: 0,
                  selectedExtrasPrices: [],
                  remark: _remark ?? '',
                );
                final cartProvider =
                    Provider.of<CartProvider>(context, listen: false);
                cartProvider.addCartItem(cartData);

                Navigator.pop(context);
              }
            : null,
        child: const Text(
          "เพิ่มเมนูอาหาร",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  Widget _buildRemarksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'หมายเหตุ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _remarksController,
          onChanged: (value) {
            setState(() {
              _remark = value;
            });
          },
          minLines: 1,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'หมายเหตุ',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
