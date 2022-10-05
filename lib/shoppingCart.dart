// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_application_1/AddOrder.dart';
// import 'package:flutter_application_1/main.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class cart extends StatefulWidget {
  List orderListName;
  List orderListPrice;

  cart(this.orderListName, this.orderListPrice);
  @override
  State<cart> createState() => _cartState(orderListName, orderListPrice);
}

class _cartState extends State<cart> {
  List orderListName;
  List orderListPrice;
  List orderListQty = [];
  List<TextEditingController> _controller =
      List.generate(100, (i) => TextEditingController(text: '1'));

  int total(List n) {
    List Total = [];
    int _subTotal = 0;
    if (n.isEmpty) {
      for (var i = 0; i < orderListPrice.length; i++) {
        n.add(1);
      }
    } else {
      for (var i = 0; i < orderListPrice.length; i++) {
        Total.add(orderListPrice[i] * n[i]);
        _subTotal += Total[i];
      }
    }

    return _subTotal;
  }

  _cartState(this.orderListName, this.orderListPrice);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text("Shopping Cart"),
            leading: Container(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          body: (orderListName.length != 0)
              ? Container(
                  child: ListView(
                    children: [
                      for (var i = 0; i < orderListName.length; i++)
                        Column(
                          children: [
                            Card(
                              child: ListTile(
                                onLongPress: () {
                                  print(orderListPrice.length);
                                  // print(_controller[i].text);
                                  // print(orderListQty);
                                },
                                title: Text(orderListName[i]),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(NumberFormat.currency(
                                            locale: 'id',
                                            symbol: 'Rp.',
                                            decimalDigits: 0)
                                        .format(orderListPrice[i])),
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: _controller[i],
                                        onChanged: (value) {
                                          setState(() {
                                            if (value.isEmpty) {
                                              value = '1';
                                            } else {
                                              orderListQty.insert(
                                                  i,
                                                  int.tryParse(
                                                      _controller[i].text));
                                              orderListQty.removeAt(i + 1);
                                            }
                                            // for (var i = 0;
                                            //     i < orderListName.length;
                                            //     i++) {
                                            //   orderListQty.add(value[i]);
                                            //   total([int.tryParse(value[i])]);
                                            // }
                                          });
                                          // print(orderListQty);
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'jumlah'),
                                      ),
                                    )
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      orderListName.removeAt(i);
                                      orderListPrice.removeAt(i);
                                    });
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                            ),
                          ],
                        ),
                      BottomAppBar(
                        child: Container(
                          child: Row(children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Column(
                                children: [
                                  Text('Total price :'),
                                  Text(NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp.',
                                          decimalDigits: 0)
                                      .format(total(orderListQty)))
                                ],
                              ),
                            ))
                          ]),
                        ),
                      )
                    ],
                  ),
                )
              : Center(
                  child: Text("tidak ada Data"),
                ),
          bottomNavigationBar: (orderListName.length != 0)
              ? BottomAppBar(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          // barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return WillPopScope(
                                onWillPop: () => Future.value(false),
                                child: AlertDialog(
                                  title: new Text("Item Berhasil Ditambahkan"),
                                  content: new SingleChildScrollView(
                                    child: Container(),
                                  ),
                                  actions: <Widget>[
                                    new TextButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        print(orderListQty);
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        FirebaseFirestore.instance
                                            .collection('orderHistory')
                                            .doc()
                                            .set({
                                          'nameItem': orderListName,
                                          'itemPrice': orderListPrice,
                                          'qty': orderListQty,
                                          'totalPrice': total(orderListQty),
                                          'date': DateFormat('dd-MM-yyyy')
                                              .format(DateTime.now())
                                        });
                                      },
                                    ),
                                  ],
                                ));
                          },
                        );
                      },
                      icon: Icon(Icons.add),
                      label: Text('Add Order')))
              : BottomAppBar()),
    );
  }
}
