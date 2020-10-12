import 'package:alice_store/models/section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HomeManager extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool editing = false;

  List<Section> _sections = [];
  List<Section> _editingSections = [];
  List<Section> get sections {
    if(editing){
      return _editingSections;
    } else {
      return _sections;
    }
  }

  //Assim que iniciar o app já carrega o _loadSections
  HomeManager(){
    _loadSections();
  }

  //Carregar todos as seções para a tela home
  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen((snapshot) { 
      _sections.clear();
      for(final DocumentSnapshot document in snapshot.docs){
        _sections.add(Section.fromDocument(document));
      }
      notifyListeners();
    });
  }

  //Entrar no modo de edição
  void enterEditing(){
    editing = true;

    _editingSections = _sections.map((s) => s.clone()).toList();

    notifyListeners();
  }

  //Funções abaixo para salvar e descartar as edições feitas na tela Home
  void saveEditing(){
    editing = false;
    notifyListeners();
  }

  void discardEditing(){
    editing = false;
    notifyListeners();
  }

}