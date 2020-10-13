import 'dart:io';

import 'package:alice_store/models/section_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier{

  String idSection;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  String _error;
  String get error => _error;
  set error(String value){
    _error = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('home/$idSection');
  StorageReference get storageRef => storage.ref().child('home/$idSection');

  Section({this.idSection, this.name, this.type, this.items}){
    items = items ?? [];
    originalItems = List.from(items);
  }

  Section.fromDocument(DocumentSnapshot document){
    idSection = document.id;
    name = document.data()['name'] as String;
    type = document.data()['type'] as String;
    items = (document.data()['items'] as List).map(
      (i) => SectionItem.fromMap(i as Map<String, dynamic>)
    ).toList();
  }

  //Adiciona mais um item na sessão
  void addItem(SectionItem item){
    items.add(item);
    notifyListeners();
  }

  //Remove um item na sessão
  void removeItem(SectionItem item){
    items.remove(item);
    notifyListeners();
  }

  //Verificando se os campos são válidos
  bool valid(){
    if(name == null || name.isEmpty){
      error = 'Título inválido';
    } else if(items.isEmpty){
      error = 'Insira ao menos uma imagem';
    } else {
      error = null;
    }
    return error == null;
  }

  //Salvando no Firebase
  Future<void> save(int pos) async {
    //Salvando os dados
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos
    };

    if(idSection == null){
      final doc = await firestore.collection('home').add(data);
      idSection = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    //Salvando as imagens
    for(final item in items){
      if(item.image is File){
        final StorageUploadTask task = storageRef.child(Uuid().v1()).putFile(item.image as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        item.image = url;
      }
    }

    for(final original in originalItems){
      if(!items.contains(original)){
        try{
          final ref = await storage.getReferenceFromUrl(
            original.image as String
          );
        // ignore: empty_catches
        } catch(e){}
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList()
    };

    await firestoreRef.update(itemsData);
  }

  Future<void> delete() async{
    await firestoreRef.delete();
    for(final item in items){
      try{
        final ref = await storage.getReferenceFromUrl(
          item.image as String
        );
      // ignore: empty_catches
      } catch(e){}
    }
  }

  Section clone(){
    return Section(
      idSection: idSection,
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