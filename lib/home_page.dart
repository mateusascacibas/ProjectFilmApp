import 'package:filmproject/widgets/button.dart';
import 'package:flutter/material.dart';
import 'dart:math';
// @dart=2.9

import 'drawer_list.dart';

class Film {
  late String name;

  Film(this.name);
}

class _HomePageState extends State<HomePage> {
  //Variaveis
  late var film = 0;
  late var cont = 11;
  late var listFilm = [];
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Film List"),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Prize Draw",
              ),
              Tab(text: "Film List")
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _body(context),
            listFilmPage(context),
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
                        height: 200,
                        color: Colors.lightBlueAccent,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Digite o filme a ser adicionado: ",
                                style: TextStyle(fontSize: 20),
                              ),
                              _widgetTextField(),
                              ElevatedButton(
                                child: const Text('Adicione'),
                                onPressed: () => _onClickAdd(context),
                              )
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
              children: [Button("Sortear filme", () => _onClickRaffle(context))],
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
    this.listFilm.removeAt(index);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Removido com sucesso!"),
          );
        });
  }

  //Metodo que chama o "add", colocando um novo filme na lista
  _onClickAdd(BuildContext context) {
    var sizeList = listFilm.length;
    this.listFilm.insert(sizeList, myController.text);
    myController.text = "";
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Adicionado com sucesso!"),
          );
        });
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
  listFilmPage(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _reloadList,
      child: ListView.builder(
        itemExtent: 50,
        itemCount: this.listFilm.length,
        itemBuilder: (context, itemCount) {
          return _filmItem(this.listFilm, itemCount);
        },
      ),
    );
  }

  //Carrega filme por filme da lista
  Stack _filmItem(List films, int index) {
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
        new IconButton(
          icon: Icon(Icons.delete_forever),
          iconSize: 30.0,
          onPressed: () => _onClickRemove(index),
            padding: EdgeInsets.only(left: 360.0)
        ),

      ],
    );
  }

  Future<void> _reloadList() async {
    var newList = await Future.delayed(Duration(seconds: 1), () => listFilm);
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
