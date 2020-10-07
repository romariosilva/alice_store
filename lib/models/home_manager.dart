import 'package:alice_store/models/section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HomeManager extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Section> sections = [];

  //Assim que iniciar o app já carrega o _loadSections
  HomeManager(){
    _loadSections();
  }

  //Carregar todos as seções para a tela home
  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen((snapshot) { 
      sections.clear();
      for(final DocumentSnapshot document in snapshot.docs){
        sections.add(Section.fromDocument(document));
      }
      notifyListeners();
    });
  }

}