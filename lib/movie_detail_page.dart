import 'package:filmproject/controllers/movie_detail_controller.dart';
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

class MovieDetailPage extends StatefulWidget{
  final int movieId;
  MovieDetailPage(this.movieId);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage>{
  final _controller = MovieDetailController();
  late var listFilm = [];
  late var listMovieAssisted = [];

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
    await _controller.fetchMovieBydId(widget.movieId);

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
      title: Text(_controller.movieDetail?.title ?? ""),
    );
  }

  _buildMovieDetail() {
    if(_controller.loading){
      return CenteredProgress();
    }
    if(_controller.movieError != null){
      return CenteredMessage(message: _controller.movieError!.message);
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
        _controller.movieDetail!.overview,
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
          Rate(_controller.movieDetail!.voteAverage),
          ChipDate(date: _controller.movieDetail!.releaseDate),
          IconButton(onPressed:add,icon: Icon(Icons.add)),
          IconButton(onPressed:assisted,icon: Icon(Icons.check))
        ],
      ),
    );
 }

  add(){
    _onClickAdd(context);
  }

  //Metodo que chama o "add", colocando um novo filme na lista
  _onClickAdd(BuildContext context) {
    var sizeList = listFilm.length;
    String str;
    if(_controller.movieDetail!.title.length > 27){
      str = _controller.movieDetail!.title.substring(0,27);
    }
    else{
      str = _controller.movieDetail!.title;
    }

    if (this.listFilm.contains(str)) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Não podemos ter o mesmo filmes 2 vezes na lista!"),
            );
          });
    } else if(this.listMovieAssisted.contains(str)){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Filme ja foi assistido!"),
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
  assisted(){
    _onClickAssisted(context);
  }
  _onClickAssisted(BuildContext context) {
    var sizeList = listMovieAssisted.length;
    String str;
    if(_controller.movieDetail!.title.length > 27){
      str = _controller.movieDetail!.title.substring(0,27);
    }
    else{
      str = _controller.movieDetail!.title;
    }
    if (this.listMovieAssisted.contains(str)) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Filme ja foi assistido!"),
            );
          });
    } else if(this.listFilm.contains(str)){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Filme já esta na sua lista!"),
            );
          });
    }else {
      showDialog(
          context: context,
          builder: (context) {
            _incrementCounterAssisted(str);
            return AlertDialog(
              title: Text("Adicionado a lista de filmes assistidos!"),
            );
          });
    }
    _reloadList();
  }

  Future<void> _reloadList() async {
    var newList = await Future.delayed(Duration(seconds: 0), () => listFilm);
    var newListMovie = await Future.delayed(Duration(seconds: 0), () => listMovieAssisted);
    setState(() {
      listFilm = newList;
      listMovieAssisted = newListMovie;
    });
  }

  _initList() async{
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    SharedPreferences listPrefsAssisted = await SharedPreferences.getInstance();
    this.listFilm = listPrefs.getStringList("counter")!.cast<dynamic>();
    this.listMovieAssisted = listPrefs.getStringList("counterFilmAssisted")!.cast<dynamic>();
    _reloadList();

  }

  _incrementCounterAssisted(String name) async {
    SharedPreferences prefsAssisted = await SharedPreferences.getInstance();
    SharedPreferences listPrefsAssisted = await SharedPreferences.getInstance();
    prefsAssisted.setString('counterFilmAssisted', name);
    this.listMovieAssisted.add(prefsAssisted.get('counterFilmAssisted'));
    var listFilmString = listMovieAssisted.cast<String>();
    listPrefsAssisted.setStringList('counterFilmAssisted', listFilmString);
  }

_incrementCounter(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPreferences listPrefs = await SharedPreferences.getInstance();
  prefs.setString('counter', name);
  this.listFilm.add(prefs.get('counter'));
  var listFilmString = listFilm.cast<String>();
  listPrefs.setStringList('counter', listFilmString);

}

 _buildCover(){
    return Image.network('https://image.tmdb.org/t/p/w500${_controller.movieDetail!.backdropPath}',);
 }
}