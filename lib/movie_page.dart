import 'package:filmproject/controllers/movie_search.dart';
import 'package:filmproject/widgets/centered_message.dart';
import 'package:filmproject/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'core/constanst.dart';
import 'movie_detail_page.dart';
import 'widgets/centered_progress.dart';
import 'controllers/movie_popular.dart';

class MoviePage extends StatefulWidget{
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage>{
  final _controller = MovieController();
  final _scrollController = ScrollController();
  final _controllerSearch = MovieControllerSearch();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Filmes');
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
        if(_controller.currentPage == lastPage){
          lastPage++;
          await _controller.fetchAllMovies(page: lastPage);
          setState(() {

          });
        }
      }
    });
  }

  _initialize() async{
    setState(() {
      _controller.loading = true;
    });

    await _controller.fetchAllMovies(page: lastPage);

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
      title: Text(kAppName),
      actions: [
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

    return GridView.builder(controller: _scrollController,
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
    return MovieCard(
      posterPath: movie.posterPath,
      onTap: () => _openDetailPage(movie.id),
    );
  }

  _openDetailPage(int id) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MovieDetailPage(id)));
  }
}