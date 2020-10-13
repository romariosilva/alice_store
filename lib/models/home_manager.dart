import 'package:alice_store/models/section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HomeManager extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool editing = false;
  bool loading = false;

  final List<Section> _sections = [];
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
    firestore.collection('home').orderBy('pos').snapshots().listen((snapshot) { 
      _sections.clear();
      for(final DocumentSnapshot document in snapshot.docs){
        _sections.add(Section.fromDocument(document));
      }
      notifyListeners();
    });
  }

  //Adicionar uma nova sessão
  void addSection(Section section){
    _editingSections.add(section);
    notifyListeners();
  }

  //Remover Sessão
  void removeSection(Section section){
    _editingSections.remove(section);
    notifyListeners();
  }

  //Entrar no modo de edição
  void enterEditing(){
    editing = true;

    _editingSections = _sections.map((s) => s.clone()).toList();

    notifyListeners();
  }

  //Funções abaixo para salvar e descartar as edições feitas na tela Home
  Future<void> saveEditing() async{
    //Verificando se os campos são válidos
    bool valid = true;
    for(final section in _editingSections){
      if(!section.valid()) valid = false;
    }
    if(!valid) return;

    loading = true;
    notifyListeners();

    int pos = 0;
    //Salvar no Firebase
    for(final section in _editingSections){
      await section.save(pos);
      pos++;
    }

    //Verificando e a sessão ainda existe para ser deletada
    for(final section in List.from(_sections)){
      if(!_editingSections.any((element) => element.idSection == section.idSection)){
        await section.delete();
      }
    }

    loading = false;
    editing = false;
    notifyListeners();
  }

  void discardEditing(){
    editing = false;
    notifyListeners();
  }

}