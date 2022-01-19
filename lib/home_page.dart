

import 'package:filmproject/movie_page.dart';
import 'package:filmproject/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'controllers/movie_popular.dart';


import 'package:shared_preferences/shared_preferences.dart';
// @dart=2.9

import 'drawer_list.dart';

class Film {
  late String name;

  Film(this.name);
}

class _HomePageState extends State<HomePage> {
  //Variaveis
  late var filmes = "";
  late var film = 0;
  late var cont = 11;
  late var listFilm = [];
  final myController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    listFilmPage(context, this.listFilm);
    return DefaultTabController(
      length: 3,
      child: Scaffold(

        appBar: AppBar(
          title: Text("Filme de Hoje"),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Sorteio",
              ),
              Tab(text: "Lista"),
              Tab(text: "Populares"),

            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _body(context),
            listFilmPage(context,this.listFilm),
            MoviePage(),
            //_tab2(),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.add),
              heroTag: "btn2",
              onPressed: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        color: Colors.lightBlueAccent,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "Digite o filme a ser adicionado: ",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                _widgetTextField(),
                                ElevatedButton(
                                    child: const Text('Adicione'),
                                    onPressed: () => _onClickAdd(context)),
                              ],
                            ),
                          ),
                      );
                    });
              },
            ),
          ],
        ),
        drawer: DrawerList(),
      ),
    );
  }

  //Corpo Home Page
  _body(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 40),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _text(),
            _image("assets/images/cine.jpg"),
            _button(),
          ],
        ),
      ),
    );
  }

  //Texto presente na Home Page
  _text() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "Qual o filme de hoje? ",
        style: TextStyle(
            color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  //Button presente na Home Page
  _button() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Builder(builder: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button("Sortear filme", () => _onClickRaffle(context))
              ],
            ),
          ],
        );
      }),
    );
  }

  //Método que chama o sorteio
  _onClickRaffle(context2) {
    if (this.listFilm.length == 0) {
      showDialog(
          context: context2,
          builder: (context2) {
            return AlertDialog(
              title: Text("Por favor, insira um filme! Sua lista está vazia."),
            );
          });
    } else {
      this.film = Random().nextInt(this.listFilm.length);
      showDialog(
          context: context2,
          builder: (context2) {
            return AlertDialog(
              title: Text("O filme sorteado é: " + this.listFilm[film]),
            );
          });
    }
  }

  //Coloca a imagem na Home Page
  _image(String text) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Image.asset(
          text,
          fit: BoxFit.contain,
          width: 250,
        ),
      ),
    );
  }

  //Metodo que chama o "Remove", removendo um filme na lista
  _onClickRemove(index) {
    _removeCounter(index);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Removido com sucesso!"),
          );
        });
    _reloadList();
  }

  _onClickEdit(int index) async {
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    myController.text = this.listFilm[index];
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            color: Colors.lightBlueAccent,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Digite o nome do filme: ",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _widgetTextField(),
                    ElevatedButton(
                        child: const Text('Edite'),
                        onPressed: () => _editCounter(index)),
                  ],
                ),
              ),
          );
        });
      _reloadList();
  }

  _removeCounter(int index) async {
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    this.listFilm.removeAt(index);
    var listFilmString = listFilm.cast<String>();
    listPrefs.setStringList('counter', listFilmString);
  }

  _editCounter(int index) async {
    if(myController.text == ""){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Por favor, preencha alguma coisa!"),
            );
          });
    }else if(this.listFilm.contains(myController.text)){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Não podemos ter o mesmo filmes 2 vezes na lista!"),
            );
          });
    }
    else {
      SharedPreferences listPrefs = await SharedPreferences.getInstance();
      this.listFilm[index] = myController.text;
      var listFilmString = listFilm.cast<String>();
      listPrefs.setStringList('counter', listFilmString);
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Edição concluida com sucesso!"),
            );
          });

    }
    myController.text = "";
  }

  _incrementCounter(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    prefs.setString('counter', name);
    this.listFilm.add(prefs.get('counter'));
    var listFilmString = listFilm.cast<String>();
    listPrefs.setStringList('counter', listFilmString);

  }

  //Metodo que chama o "add", colocando um novo filme na lista
  _onClickAdd(BuildContext context) {
    if(myController.text == ""){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Por favor, preencha alguma coisa!"),
            );
          });
    }else if(this.listFilm.contains(myController.text)){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Não podemos ter o mesmo filmes 2 vezes na lista!"),
            );
          });
    }
    else{
      var sizeList = listFilm.length;
      // this.listFilm.insert(sizeList, myController.text);
      _incrementCounter(myController.text);
      // print("Lista do flutter: " + _getCounter());
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Adicionado com sucesso!"),
            );
          });
      _reloadList();
    }
    myController.text = "";
  }

  _initList() async{
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    this.listFilm = listPrefs.getStringList("counter")!.cast<dynamic>();
    _reloadList();

  }

  _getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.getString('counter');
  }

  //Gera o field para digitar, na home page
  _widgetTextField() {
    return TextField(
      controller: myController,
      style: TextStyle(
          fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red),
      maxLength: 20,
    );
  }

  /////////////////////////////////////////////////////////////////////////////////
  //Carrega a lista de filmes
  listFilmPage(BuildContext context, List list) {
    _initList();
    var tem = this.listFilm.length == 0;
        return tem ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: RefreshIndicator(
              onRefresh: _reloadList,
              child: ListView.builder(
                itemExtent: 50,
                itemCount: 1,
                itemBuilder: (context, itemCount) {
                  return Text("Sem filmes atualmente.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),);
                },
              ),
            ),
          ),
        ): Container(
          child: RefreshIndicator(
            onRefresh: _reloadList,
            child: ListView.builder(
              itemExtent: 50,
              itemCount: this.listFilm.length,
              itemBuilder: (context, itemCount) {
                return _filmItem(this.listFilm, itemCount);
              },
            ),
          ),
        );

    }

  //Carrega filme por filme da lista
   _filmItem(List films, int index) {
    if(index < this.listFilm.length){
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration( //                    <-- BoxDecoration
              border: Border(bottom: BorderSide()),
            ),
            child: Padding(

              padding: const EdgeInsets.all(7.0),
              child: Text(
                listFilm[index],
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.edit),
                      iconSize: 30.0,
                      onPressed: () => _onClickEdit(index),
                      padding: EdgeInsets.only(left: 280.0)
                  ),
                  IconButton(
                      icon: Icon(Icons.delete_forever),
                      iconSize: 30.0,
                      onPressed: () => _onClickRemove(index),
                      padding: EdgeInsets.only(left: 10.0)
                  ),

                ],
              ),
            ),

        ],
      );
    }else{
      return Text("");
    }
  }

  Future<void> _reloadList() async {
    var newList = await Future.delayed(Duration(seconds: 0), () => listFilm);
    setState(() {
      listFilm = newList;
    });
  }
}


class HomePage extends StatefulWidget {
  //Local Storage
  @override
  _HomePageState createState() => _HomePageState();
}
