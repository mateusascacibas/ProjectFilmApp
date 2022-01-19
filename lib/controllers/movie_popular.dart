import 'package:dartz/dartz.dart';
import 'package:filmproject/Errors/movier_error.dart';
import 'package:filmproject/widgets/models/movie_model.dart';
import 'package:filmproject/widgets/models/movie_response_model.dart';
import 'package:filmproject/repositories/movie_repository.dart';

class MovieController {
  final _repository = MovieRepository();

  late MovieResponseModel? movieResponseModel;
  late MovieError? movieError;
  bool loading = true;

  List<MovieModel> get movies => movieResponseModel?.movies ?? <MovieModel>[];

  int get moviesCounts => movies.length;

  bool get hasMovies => moviesCounts != 0;

  int get totalPages => movieResponseModel?.totalPages ?? 1;

  int get currentPage => movieResponseModel?.page ?? 1;

  Future<Either<MovieError, MovieResponseModel>> fetchAllMovies(
      {int page = 1}) async {
    movieError = null;
    movieResponseModel = null;
    final result = await _repository.fetchAllMovies(page);
    result.fold((error) => movieError = error, (movie) {
      if (movieResponseModel == null) {
        movieResponseModel = movie;
      } else {
        movieResponseModel?.page = movie.page;
        movieResponseModel?.movies.addAll(movie.movies);
      }
    },
    );
    return result;
  }
}