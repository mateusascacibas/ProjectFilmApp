import 'dart:math';

import 'package:filmproject/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer_list.dart';

class _FoodPage extends State<FoodPage> {
  //Variaveis
  late var food = 0;
  late var cont = 11;
  late var listFood = [];
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        appBar: AppBar(
          title: Text("Lanche de Hoje"),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Sorteio",
              ),
              Tab(text: "Lista"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _body(context),
            listFoodPage(context,this.listFood),
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
                                "Digite o lanche a ser adicionado: ",
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
            _image("assets/images/food.jpg"),
            _button(),
          ],
        ),
      ),
    );
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

  _text() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "Qual o lanche de hoje? ",
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
                Button("Sortear lanche", () => _onClickRaffle(context))
              ],
            ),
          ],
        );
      }),
    );
  }
  //Método que chama o sorteio
  _onClickRaffle(context2) {
    if (this.listFood.length == 0) {
      showDialog(
          context: context2,
          builder: (context2) {
            return AlertDialog(
              title: Text("Por favor, insira um lanche! Sua lista está vazia."),
            );
          });
    } else {
      this.food = Random().nextInt(this.listFood.length);
      showDialog(
          context: context2,
          builder: (context2) {
            return AlertDialog(
              title: Text("O lanche sorteado é: " + this.listFood[food]),
            );
          });
    }
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
    }else if(this.listFood.contains(myController.text)){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Não podemos ter o mesmo lanche 2 vezes na lista!"),
            );
          });
    }
    else{
      var sizeList = listFood.length;
      // this.listFood.insert(sizeList, myController.text);
      _incrementFood(myController.text);
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

  _incrementFood(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    prefs.setString('food', name);
    this.listFood.add(prefs.get('food'));
    var listFoodString = listFood.cast<String>();
    listPrefs.setStringList('food', listFoodString);

  }

  Future<void> _reloadList() async {
    var newList = await Future.delayed(Duration(seconds: 0), () => listFood);
    setState(() {
      listFood = newList;
    });
  }
  _initList() async{
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    this.listFood = listPrefs.getStringList("food")!.cast<dynamic>();
    _reloadList();

  }

  /////////////////////////////////////////////////////////////////////////////////
  //Carrega a lista de filmes
  listFoodPage(BuildContext context, List list) {
    _initList();
    var tem = this.listFood.length == 0;
    return tem ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: RefreshIndicator(
          onRefresh: _reloadList,
          child: ListView.builder(
            itemExtent: 50,
            itemCount: 1,
            itemBuilder: (context, itemCount) {
              return Text("Sem lanches atualmente.",
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
          itemCount: this.listFood.length,
          itemBuilder: (context, itemCount) {
            return _foodItem(this.listFood, itemCount);
          },
        ),
      ),
    );

  }

  //Carrega comida por comida da lista
  _foodItem(List food, int index) {
    if(index < this.listFood.length){
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
                listFood[index],
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

  _onClickEdit(int index) async {
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    myController.text = this.listFood[index];
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
                    "Digite o nome do lanche: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _widgetTextField(),
                  ElevatedButton(
                      child: const Text('Edite'),
                      onPressed: () => _editFood(index)),
                ],
              ),
            ),
          );
        });
    _reloadList();
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

  _editFood(int index) async {
    if(myController.text == ""){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Por favor, preencha alguma coisa!"),
            );
          });
    }else if(this.listFood.contains(myController.text)){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Não podemos ter o mesmo lanche 2 vezes na lista!"),
            );
          });
    }
    else {
      SharedPreferences listPrefs = await SharedPreferences.getInstance();
      this.listFood[index] = myController.text;
      var listFilmString = listFood.cast<String>();
      listPrefs.setStringList('food', listFilmString);
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

  _onClickRemove(index) {
    _removeFood(index);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Removido com sucesso!"),
          );
        });
    _reloadList();
  }

  _removeFood(int index) async {
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    this.listFood.removeAt(index);
    var listFilmString = listFood.cast<String>();
    listPrefs.setStringList('food', listFilmString);
  }
}

class FoodPage extends StatefulWidget {
  //Local Storage
  @override
  _FoodPage createState() => _FoodPage();
}
