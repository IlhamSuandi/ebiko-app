import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

deleteDialog(BuildContext context, DocumentSnapshot document, String name) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference items = firestore.collection(name);
  Widget acceptButton = TextButton(
      onPressed: () {
        items.doc(document.id).delete();
        Navigator.of(context, rootNavigator: true).pop(context);
      },
      child: Text('Iya'));
  Widget rejectButton = TextButton(
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(context),
      child: Text('Tidak'));
  AlertDialog deleteDialog = AlertDialog(
    actions: [rejectButton, acceptButton],
    title: Text('Item akan Dihapus'),
    content: Text('Kamu yakin ingin menghapus item ini?'),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return deleteDialog;
    },
  );
}
