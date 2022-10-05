import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Alert-AddItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Alert-DeleteItem.dart';
import 'package:flutter_application_1/items.dart';
import 'package:intl/intl.dart';

class AddDatabase extends StatefulWidget {
  @override
  State<AddDatabase> createState() => _AddDatabaseState();
}

class _AddDatabaseState extends State<AddDatabase> {
  Function onDelete;
  TextEditingController searchController = TextEditingController();
  String searchString;
  List<Items> itemlist = [];
  List<Items> Updateitemlist = [];
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
    // CollectionReference items = firestore.collection('items');
    void addItemData(Items item) {
      setState(() {
        itemlist.add(item);
      });
    }

    void showItemDialog() {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: alertAddItem(addItemData),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        },
      );
    }

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
                          return Card(
                            child: ListTile(
                              onLongPress: () {},
                              title: Text(document['Name']),
                              subtitle: Text(
                                NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp.',
                                        decimalDigits: 0)
                                    .format(document['Price']),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  deleteDialog(context, document, 'items');
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ),
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
          onPressed: showItemDialog,
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
