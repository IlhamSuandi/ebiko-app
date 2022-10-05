import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Alert-DeleteItem.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text('History'),
        ),
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orderHistory')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Ada Kesalahan, Coba Lagi!');
                  } else if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return (snapshot.hasData)
                      ? ListView(
                          // padding:
                          //     EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                          children: snapshot.data.docs.map(
                            (DocumentSnapshot document) {
                              return Card(
                                margin: EdgeInsets.all(20),
                                child: SizedBox(
                                  child: InkWell(
                                    onLongPress: (() {
                                      // print(document);
                                      deleteDialog(
                                          context, document, 'orderHistory');
                                    }),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Column(
                                                children: [
                                                  Text('Date'),
                                                  Text(document['date']
                                                      .toString()),
                                                ],
                                              )),
                                          for (var i = 0;
                                              i < document['nameItem'].length;
                                              i++)
                                            ListTile(
                                              title:
                                                  Text(document['nameItem'][i]),
                                              subtitle: Text("(" +
                                                  document['qty'][i]
                                                      .toString() +
                                                  ")"),
                                              trailing: Text(
                                                NumberFormat.currency(
                                                        locale: 'id',
                                                        symbol: 'Rp.',
                                                        decimalDigits: 0)
                                                    .format(
                                                        document['itemPrice']
                                                            [i]),
                                              ),
                                            ),
                                          Container(
                                            alignment:
                                                AlignmentDirectional.topCenter,
                                            padding: EdgeInsets.all(20),
                                            child: Text(
                                              NumberFormat.currency(
                                                      locale: 'id',
                                                      symbol: 'Rp.',
                                                      decimalDigits: 0)
                                                  .format(
                                                      document['totalPrice']),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        )
                      : Center(
                          child: Text('Tidak ada History'),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
