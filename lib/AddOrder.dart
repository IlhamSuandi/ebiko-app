import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_1/Alert-AddItem.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Alert-DeleteItem.dart';
// import 'package:flutter_application_1/items.dart';
import 'package:flutter_application_1/shoppingCart.dart';
import 'package:intl/intl.dart';

class AddOrder extends StatefulWidget {
  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  Function onDelete;
  TextEditingController searchController = TextEditingController();
  String searchString;
  List orderListName = [];
  List orderListPrice = [];
  List orderListIndex = [];
  List<bool> clickme = [];
  bool isTrue = false;
  final Stream<QuerySnapshot> itemsData =
      FirebaseFirestore.instance.collection('items').snapshots();

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  onSearchChanged() {}

  Widget build(BuildContext context) {
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    // CollectionReference items = FirebaseFirestore.instance.collection('items');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add/Remove Database'),
        ),
        body: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchString = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Item',
                contentPadding: EdgeInsets.only(left: 20, top: 13),
                suffixIcon: Container(
                  padding: EdgeInsets.only(right: 17),
                  child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          searchString = "";
                          searchController.clear();
                        });
                      }),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (searchString == null || searchString.trim() == "")
                    ? FirebaseFirestore.instance.collection('items').snapshots()
                    : FirebaseFirestore.instance
                        .collection("items")
                        .where("searchIndex", arrayContains: searchString)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Text('Ada Kesalahan, Coba Lagi!');
                  else if (!snapshot.hasData)
                    return Container(
                      child: Center(
                        child: Text('Tidak Ada Item'),
                      ),
                    );
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      return ListView(
                          children: snapshot.data.docs.map(
                        (DocumentSnapshot document) {
                          String nameItem = document['Name'];
                          int priceItem = document['Price'];
                          return Card(
                            child: ListTile(
                                onLongPress: () {
                                  print(orderListName);
                                  print(orderListPrice);
                                },
                                title: Text(nameItem),
                                subtitle: Text(
                                  NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp.',
                                          decimalDigits: 0)
                                      .format(priceItem),
                                ),
                                trailing: Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          clickme.add(!isTrue);
                                          isTrue = !isTrue;
                                          if (!orderListName
                                              .contains(nameItem)) {
                                            orderListName.add(nameItem);
                                            orderListPrice.add(priceItem);
                                            orderListIndex
                                                .add(document["searchIndex"]);
                                            print(clickme);
                                          }
                                          ;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ],
                                )),
                          );
                        },
                      ).toList());
                  }
                },
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => cart(orderListName, orderListPrice),
              ),
            );
          },
          child: Icon(Icons.shopping_basket),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
