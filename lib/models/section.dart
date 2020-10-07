import 'package:cloud_firestore/cloud_firestore.dart';

class Section {

  String name;
  String type;

  Section.fromDocument(DocumentSnapshot document){
    name = document.data()['name'] as String;
    type = document.data()['type'] as String;
  }

}