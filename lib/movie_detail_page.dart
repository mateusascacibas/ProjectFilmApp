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
          IconButton(onPressed:add,icon: Icon(Icons.add))
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

    if (this.listFilm.contains(_controller.movieDetail!.title)) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Não podemos ter o mesmo filmes 2 vezes na lista!"),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            _incrementCounter(_controller.movieDetail!.title);
            return AlertDialog(
              title: Text("Adicionado com sucesso!"),
            );
          });
      _reloadList();
    }
  }

  Future<void> _reloadList() async {
    var newList = await Future.delayed(Duration(seconds: 0), () => listFilm);
    setState(() {
      listFilm = newList;
    });
  }

  _initList() async{
    SharedPreferences listPrefs = await SharedPreferences.getInstance();
    this.listFilm = listPrefs.getStringList("counter")!.cast<dynamic>();
    _reloadList();

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