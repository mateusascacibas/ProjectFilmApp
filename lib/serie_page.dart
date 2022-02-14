
import 'package:filmproject/devProfile.dart';
import 'package:filmproject/serie_detail_page.dart';
import 'package:filmproject/widgets/centered_message.dart';
import 'package:filmproject/widgets/centered_progress.dart';
import 'package:filmproject/widgets/models/tv_card.dart';
import 'package:flutter/material.dart';

import 'controllers/serie_popular.dart';

class SeriePage extends StatefulWidget{
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<SeriePage>{
  final _controller = SerieController();
  final _scrollController = ScrollController();
  int cont = 0;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Series');
  int lastPage = 1;

  @override
  void initState(){
    super.initState();
    _initScrollListener();
    _initialize();
  }

   _initScrollListener() {
    _scrollController.addListener(() async{
      if(_scrollController.offset >= _scrollController.position.maxScrollExtent){
          lastPage++;
          await _controller.fetchAllMovies(lastPage);
          setState(() {
          });
        }
    });
  }

  _initialize() async{
    setState(() {
      lastPage = 1;
      _controller.loading = true;
    });

    await _controller.fetchAllMovies(lastPage);

    setState(() {
      _controller.loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: _buildAppBar() ,
      body: _buildMovieGrid(),
    );
  }

  _buildAppBar(){
    return AppBar(
      title: Text("Serie de hoje?"),

      // title: TextField(
      //   decoration:
      //   InputDecoration(border: InputBorder.none, hintText: 'Search'),
      // ),
      actions: [
        IconButton(onPressed: _back, icon: Icon(Icons.arrow_left)),
        IconButton(onPressed: _next, icon: Icon(Icons.arrow_right)),
        IconButton(onPressed: _initialize, icon: Icon(Icons.refresh))
      ],
    );
  }

  // _buildAppBar() {
  //  return AppBar(
  //    title: customSearchBar,
  //    automaticallyImplyLeading: false,
  //    actions: [
  //      IconButton(
  //        onPressed: () {
  //          setState(() {
  //            if (customIcon.icon == Icons.search) {
  //                customIcon = const Icon(Icons.cancel);
  //                customSearchBar = const ListTile(
  //
  //                  title: TextField(
  //                    decoration: InputDecoration(
  //                      hintText: 'digite o nome do filme...',
  //                      hintStyle: TextStyle(
  //                        color: Colors.white,
  //                        fontSize: 18,
  //                        fontStyle: FontStyle.italic,
  //                      ),
  //                      border: InputBorder.none,
  //                    ),
  //                    style: TextStyle(
  //                      color: Colors.white,
  //                    ),
  //                  ),
  //                );
  //
  //            } else {
  //              customIcon = const Icon(Icons.search);
  //              customSearchBar = const Text('Filmes');
  //            }
  //          });
  //        },
  //        icon: const Icon(Icons.search),
  //      )
  //    ],
  //    centerTitle: true,
  //  );
  // }

  _buildMovieGrid() {
    if(_controller.loading){
      return CenteredProgress();
     }
    if(_controller.movieError != null){
      return CenteredMessage(message: _controller.movieError!.message);
    }

    return GridView.builder(
        padding: const EdgeInsets.all(2.0),
        itemCount: _controller.moviesCounts,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      childAspectRatio: 0.65,
      crossAxisSpacing: 2
    ), itemBuilder: _buildMovieCard);
  }



  Widget _buildMovieCard(BuildContext context, int index) {
    final movie = _controller.movies[index];
    var response;
    if(movie.posterPath == null && movie.backdropPath == null){
     response =  "assets/images/mateus.jpg";
    }
    else{
      response = movie.posterPath == null? movie.backdropPath: movie.posterPath;
    }
      return TvCard(
        posterPath: response,
        onTap: () => response == "assets/images/mateus.jpg" ? _openDevProfile() : _openDetailPage(movie.id),
      );
  }

  _openDetailPage(int id) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SerieDetailPage(id)));
  }
  _openDevProfile() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => devProfile()));
  }

  Future<void> _back() async {
    setState(() {
      lastPage -= 1;
      _controller.loading = true;
    });

    await _controller.fetchAllMovies(lastPage);

    setState(() {
      _controller.loading = false;
    });

  }

  Future<void> _next() async {
    setState(() {
      lastPage += 1;
      _controller.loading = true;
    });

    await _controller.fetchAllMovies(lastPage);

    setState(() {
      _controller.loading = false;
    });

  }



}