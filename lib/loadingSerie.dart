import 'package:filmproject/serie_page.dart';
import 'package:filmproject/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'controllers/movie_popular.dart';


import 'package:shared_preferences/shared_preferences.dart';
// @dart=2.9

import 'drawer_list.dart';

class TvLoading {
  late String name;

  TvLoading(this.name);
}

class _LoadingSerie extends State<LoadingSerie> {
  //Variaveis
  late var series = "";
  late var tv = 0;
  late var cont = 11;
  late var listtv = [];
  late var listTvAssisted = [];
  final myController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    listtvPage(context, this.listtv);
    listTvAssistedPage(context, this.listTvAssisted);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Serie de Hoje"),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Sorteio",
              ),
              Tab(text: "Lista"),
              Tab(text: "Populares"),
              Tab(text: "Assistidas"),

            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _body(context),
            listtvPage(context, this.listtv),
            SeriePage(),
            listTvAssistedPage(context, this.listTvAssisted)

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
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.6,
                        color: Colors.lightBlueAccent,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Digite a serie a ser adicionada: ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
            _image("assets/images/series.jpg"),
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
        "Qual a serie de hoje? ",
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
                Button("Sortear Serie", () => _onClickRaffle(context))
              ],
            ),
          ],
        );
      }),
    );
  }

  //Método que chama o sorteio
  _onClickRaffle(context2) {
    if (this.listtv.length == 0) {
      showDialog(
          context: context2,
          builder: (context2) {
            return AlertDialog(
              title: Text("Por favor, insira uma serie! Sua lista está vazia."),
            );
          });
    } else {
      this.tv = Random().nextInt(this.listtv.length);
      showDialog(
          context: context2,
          builder: (context2) {
            return AlertDialog(
              title: Text("A serie sorteada é: " + this.listtv[tv]),
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

  //Metodo que chama o "Remove", removendo um tve na lista
  _onClickRemove(index, String type) {
    if(type == "assisted"){
      _removecounterSerieAssisted(index);
    }else{
      _removecounterSerie(index);
    }


    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Removida com sucesso!"),
          );
        });
    myController.text = "";
    _reloadList();
  }

  _onClickAssisted(index) async {
    SharedPreferences listPrefsSerie = await SharedPreferences.getInstance();
    var sizeList = listTvAssisted.length;
    String str;
    if (this.listTvAssisted.contains(this.listtv[index])) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Não podemos ter a mesma serie 2 vezes na lista!"),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            if (this.listtv[index].length > 33) {
              str = this.listtv[index].substring(0, 33);
            }
            else {
              str = this.listtv[index];
            }
            _incrementCounterAssisted(str);
            _removecounterSerie(index);
            return AlertDialog(
              title: Text("Adicionado a lista de series assistidas!"),
            );
          });
    }
      _reloadList();

  }


  _onClickEdit(int index) async {
    SharedPreferences listPrefsSerie = await SharedPreferences.getInstance();
    myController.text = this.listtv[index];
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.6,
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Digite o nome da serie: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _widgetTextField(),
                  ElevatedButton(
                      child: const Text('Edite'),
                      onPressed: () => _editcounterSerie(index)),
                ],
              ),
            ),
          );
        });
    myController.text = "";
    _reloadList();
  }

  _removecounterSerie(int index) async {
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    this.listtv.removeAt(index);
    var listtvString = listtv.cast<String>();
    listPrefs.setStringList('counterSerie', listtvString);
  }

  _removecounterSerieAssisted(int index) async {
    SharedPreferences listPrefsAssisted = await SharedPreferences.getInstance();
    this.listTvAssisted.removeAt(index);
    var listtvString = listTvAssisted.cast<String>();
    listPrefsAssisted.setStringList('counterSerieAssisted', listtvString);
  }

  _editcounterSerie(int index) async {
    if (myController.text == "") {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Por favor, preencha alguma coisa!"),
            );
          });
    } else if (this.listtv.contains(myController.text)) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Não podemos ter a mesma serie 2 vezes na lista!"),
            );
          });
    }
    else {
      SharedPreferences listPrefs = await SharedPreferences.getInstance();
      this.listtv[index] = myController.text;
      var listtvString = listtv.cast<String>();
      listPrefs.setStringList('counterSerie', listtvString);
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

  _incrementcounterSerie(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    prefs.setString('counterSerie', name);
    this.listtv.add(prefs.get('counterSerie'));
    var listtvString = listtv.cast<String>();
    listPrefs.setStringList('counterSerie', listtvString);
  }

  _incrementCounterAssisted(String name) async {
    SharedPreferences prefsAssisted = await SharedPreferences.getInstance();
    SharedPreferences listPrefsAssisted = await SharedPreferences.getInstance();
    prefsAssisted.setString('counterSerieAssisted', name);
    this.listTvAssisted.add(prefsAssisted.get('counterSerieAssisted'));
    var listFilmString = listTvAssisted.cast<String>();
    listPrefsAssisted.setStringList('counterSerieAssisted', listFilmString);
  }

  //Metodo que chama o "add", colocando um novo tve na lista
  _onClickAdd(BuildContext context) {
    if (myController.text == "") {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Por favor, preencha alguma coisa!"),
            );
          });
    } else if (this.listtv.contains(myController.text)) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Não podemos ter a mesma serie 2 vezes na lista!"),
            );
          });
    }
    else {
      var sizeList = listtv.length;
      // this.listtv.insert(sizeList, myController.text);
      _incrementcounterSerie(myController.text);
      // print("Lista do flutter: " + _getcounterSerie());
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

  _initList() async {
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    SharedPreferences listPrefsAssisted = await SharedPreferences.getInstance();
    this.listtv = listPrefs.getStringList("counterSerie")!.cast<dynamic>();
    this.listTvAssisted = listPrefsAssisted.getStringList("counterSerieAssisted")!.cast<dynamic>();
    _reloadList();
  }

  _getcounterSerie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.getString('counterSerie');
  }

  //Gera o field para digitar, na home page
  _widgetTextField() {
    return TextField(
      controller: myController,
      style: TextStyle(
          fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red),
      maxLength: 23,
    );
  }

  /////////////////////////////////////////////////////////////////////////////////
  //Carrega a lista de series
  listTvAssistedPage(BuildContext context, List list) {
    _initList();
    var tem = this.listTvAssisted.length == 0;
    return tem ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: RefreshIndicator(
          onRefresh: _reloadList,
          child: ListView.builder(
            itemExtent: 50,
            itemCount: 1,
            itemBuilder: (context, itemCount) {
              return Text("Ainda nao assistiu nenhuma serie.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),);
            },
          ),
        ),
      ),
    ) : Container(
      child: RefreshIndicator(
        onRefresh: _reloadList,
        child: ListView.builder(
          itemExtent: 50,
          itemCount: this.listTvAssisted.length,
          itemBuilder: (context, itemCount) {
            return _tvItemAssisted(this.listTvAssisted, itemCount);
          },
        ),
      ),
    );
  }

  listtvPage(BuildContext context, List list) {
    _initList();
    var tem = this.listtv.length == 0;
    return tem ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: RefreshIndicator(
          onRefresh: _reloadList,
          child: ListView.builder(
            itemExtent: 50,
            itemCount: 1,
            itemBuilder: (context, itemCount) {
              return Text("Sem series atualmente.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),);
            },
          ),
        ),
      ),
    ) : Container(
      child: RefreshIndicator(
        onRefresh: _reloadList,
        child: ListView.builder(
          itemExtent: 50,
          itemCount: this.listtv.length,
          itemBuilder: (context, itemCount) {
            return _tvItem(this.listtv, itemCount);
          },
        ),
      ),
    );
  }

  //Carrega tve por tve da lista
  _tvItemAssisted(List tvs, int index) {
    if (index < this.listTvAssisted.length) {
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
    listTvAssisted[index],
    textAlign: TextAlign.justify,
    style: TextStyle(
    fontSize: 18,
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
                      icon: Icon(Icons.delete_forever),
                      iconSize: 30.0,
                      onPressed: () => _onClickRemove(index, "assisted"),
                      padding: EdgeInsets.only(left: 280)
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


  _tvItem(List tvs, int index) {
    if (index < this.listtv.length) {
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
                listtv[index],
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 18,
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
                    padding: EdgeInsets.only(left: 230.0)
                ),
                IconButton(
                    icon: Icon(Icons.delete_forever),
                    iconSize: 30.0,
                    onPressed: () => _onClickRemove(index, "counter"),
                    padding: EdgeInsets.only(left: 0.1)
                ),
                IconButton(
                    icon: Icon(Icons.check),
                    iconSize: 25.0,
                    onPressed: () => _onClickAssisted(index),
                    padding: EdgeInsets.only(left: 0.1)
                ),

              ],
            ),
          ),

        ],
      );
    } else {
      return Text("");
    }
  }

  Future<void> _reloadList() async {
    var newList = await Future.delayed(Duration(seconds: 0), () => listtv);
    var newListAssisted = await Future.delayed(
        Duration(seconds: 0), () => listTvAssisted);
    setState(() {
      listtv = newList;
      listTvAssisted = newListAssisted;
    });
  }
}


class LoadingSerie extends StatefulWidget {
  //Local Storage
  @override
  _LoadingSerie createState() => _LoadingSerie();
}
