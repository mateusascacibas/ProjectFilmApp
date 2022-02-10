import 'package:filmproject/controllers/movie_detail_controller.dart';
import 'package:filmproject/controllers/serie_detail_controller.dart';
import 'package:filmproject/widgets/button.dart';
import 'package:filmproject/widgets/centered_message.dart';
import 'package:filmproject/widgets/movie_card.dart';
import 'package:filmproject/widgets/rate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constanst.dart';
import 'widgets/centered_progress.dart';
import 'controllers/movie_popular.dart';
import 'widgets/chip_date.dart';

class SerieDetailPage extends StatefulWidget{
  final int serieID;
  SerieDetailPage(this.serieID);

  @override
  _SerieDetailPageState createState() => _SerieDetailPageState();
}

class _SerieDetailPageState extends State<SerieDetailPage>{
  final _controller = SerieDetailController();
  late var listSerie = [];
  late var listSerieAssisted = [];

  @override
  void initState(){
    super.initState();
    _initialize();
  }

  _initialize() async{
    _initList();
    setState(() {
      _controller.loading = true;
    });
    await _controller.fetchMovieBydId(widget.serieID);

    setState(() {
      _controller.loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar() ,
      body: _buildMovieDetail(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(_controller.serieDetail?.title ?? ""),
    );
  }

  _buildMovieDetail() {
    if(_controller.loading){
      return CenteredProgress();
    }
    if(_controller.serieError != null){
      return CenteredMessage(message: _controller.serieError!.message);
    }

   return ListView(
     children: [
       _buildCover(),
       _buildStatus(),
       _buildOverview(),
     ],
   );
  }

  _buildOverview() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10,0, 10, 10),
      child: Text(
        _controller.serieDetail!.overview,
        textAlign:  TextAlign.justify,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

 _buildStatus(){
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Rate(_controller.serieDetail!.voteAverage),
          IconButton(onPressed:add,icon: Icon(Icons.add)),
          IconButton(onPressed:assisted,icon: Icon(Icons.check))
        ],
      ),
    );
 }

  add(){
    _onClickAdd(context);
  }

  assisted(){
    _onClickAssisted(context);
  }
  _onClickAssisted(BuildContext context) {
    var sizeList = listSerieAssisted.length;
    String str;
    if(_controller.serieDetail!.title.length > 33){
      str = _controller.serieDetail!.title.substring(0, 33);
    }
    else{
      str = _controller.serieDetail!.title;
    }
    if (this.listSerieAssisted.contains(str)) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Serie ja foi assistida!!"),
            );
          });
    } else if(this.listSerie.contains(str)){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Serie já esta na sua lista!"),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {

            _incrementCounterAssisted(str);
            return AlertDialog(
              title: Text("Adicionado a lista de series assistidas!"),
            );
          });
    }
  }
  //Metodo que chama o "add", colocando um novo filme na lista
  _onClickAdd(BuildContext context) {
    var sizeList = listSerie.length;
    String str;
    if(_controller.serieDetail!.title.length > 33){
      str = _controller.serieDetail!.title.substring(0, 33);
    }
    else{
      str = _controller.serieDetail!.title;
    }
    if (this.listSerie.contains(str)) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Não podemos ter a mesma serie 2 vezes na lista!"),
            );
          });
    } else if(this.listSerieAssisted.contains(str)){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Serie ja foi assistida!"),
            );
          });
    }else {
      showDialog(
          context: context,
          builder: (context) {
            _incrementCounter(str);
            return AlertDialog(
              title: Text("Adicionado com sucesso!"),
            );
          });
      _reloadList();
    }
  }

  Future<void> _reloadList() async {
    var newList = await Future.delayed(Duration(seconds: 0), () => listSerie);
    var newListSerie = await Future.delayed(Duration(seconds: 0), () => listSerieAssisted);
    setState(() {
      listSerie = newList;
      listSerieAssisted = newListSerie;
    });
  }

  _initList() async{
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    SharedPreferences listPrefsAssisted = await SharedPreferences.getInstance();
    this.listSerie = listPrefs.getStringList("counterSerie")!.cast<dynamic>();
    this.listSerieAssisted = listPrefs.getStringList("counterSerieAssisted")!.cast<dynamic>();
    _reloadList();

  }

_incrementCounter(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPreferences listPrefs = await SharedPreferences.getInstance();
  prefs.setString('counterSerie', name);
  this.listSerie.add(prefs.get('counterSerie'));
  var listFilmString = listSerie.cast<String>();
  listPrefs.setStringList('counterSerie', listFilmString);

}

  _incrementCounterAssisted(String name) async {
    SharedPreferences prefsAssisted = await SharedPreferences.getInstance();
    SharedPreferences listPrefsAssisted = await SharedPreferences.getInstance();
    prefsAssisted.setString('counterSerieAssisted', name);
    this.listSerieAssisted.add(prefsAssisted.get('counterSerieAssisted'));
    var listFilmString = listSerieAssisted.cast<String>();
    listPrefsAssisted.setStringList('counterSerieAssisted', listFilmString);
  }

 _buildCover(){
    return Image.network('https://image.tmdb.org/t/p/w500${_controller.serieDetail!.backdropPath}',);
 }
}