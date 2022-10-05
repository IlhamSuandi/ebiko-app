import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/items.dart';

class alertAddItem extends StatefulWidget {
  final Function(Items) addItem;
  alertAddItem(this.addItem);
  @override
  State<alertAddItem> createState() => _alertAddItemState();
}

class _alertAddItemState extends State<alertAddItem> {
  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    // CollectionReference DatabaseItem = firestore.collection('items');

    Widget buildTextfieldString(String hint, TextEditingController controller) {
      return Container(
        padding: EdgeInsets.only(top: 25),
        // margin: EdgeInsets.all(5),
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
          ),
          controller: controller,
        ),
      );
    }

    Widget buildTextfieldInt(String hint, TextEditingController controller) {
      return Container(
        padding: EdgeInsets.only(top: 25),
        // margin: EdgeInsets.all(5),
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          autofocus: true,
          decoration: InputDecoration(
            labelText: hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
          ),
          controller: controller,
        ),
      );
    }

    var itemName = TextEditingController();
    var itemPrice = TextEditingController();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(color: Colors.white),
            height: 300,
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Add Item Data',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  buildTextfieldString('Nama Item', itemName),
                  buildTextfieldInt('Harga Item', itemPrice),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          final items = Items(itemName.text, itemPrice.text);
                          widget.addItem(items);
                          Navigator.of(context).pop();
                          var price = int.tryParse(itemPrice.text);
                          // DatabaseItem.add({
                          //   'Name': itemName.text,
                          //   'Price': int.tryParse(itemPrice.text) ?? 0
                          // });
                          _addToDatabase(itemName.text, price);
                          itemName.text = '';
                          itemPrice.text = '';
                        },
                        child: Text('Tambah Item')),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _addToDatabase(String name, int price) {
    List<String> splitList = name.split(" ");
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + 1; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }

    // print(indexList);
    print(name);
    FirebaseFirestore.instance
        .collection('items')
        .doc()
        .set({'Name': name, 'Price': price, 'searchIndex': indexList});
  }
}
