import 'package:alice_store/models/section_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Section {

  String name;
  String type;
  List<SectionItem> items;

  Section({this.name, this.type, this.items});

  Section.fromDocument(DocumentSnapshot document){
    name = document.data()['name'] as String;
    type = document.data()['type'] as String;
    items = (document.data()['items'] as List).map(
      (i) => SectionItem.fromMap(i as Map<String, dynamic>)
    ).toList();
  }

  Section clone(){
    return Section(
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList()
    );
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }

}