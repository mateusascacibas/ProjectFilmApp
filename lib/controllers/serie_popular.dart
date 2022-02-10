import 'package:dartz/dartz.dart';
import 'package:filmproject/Errors/movier_error.dart';
import 'package:filmproject/repositories/serie_repository.dart';
import 'package:filmproject/widgets/models/movie_model.dart';
import 'package:filmproject/widgets/models/movie_response_model.dart';
import 'package:filmproject/repositories/movie_repository.dart';
import 'package:filmproject/widgets/models/serie_model.dart';
import 'package:filmproject/widgets/models/serie_response_model.dart';

class SerieController {
  final _repository = SerieRepository();

  late SerieResponseModel? serieResponseModel;
  late MovieError? movieError;
  bool loading = true;

  List<SerieModel> get movies => serieResponseModel?.movies ?? <SerieModel>[];

  int get moviesCounts => movies.length;

  bool get hasMovies => moviesCounts != 0;

  int get totalPages => serieResponseModel?.totalPages ?? 1;

  int get currentPage => serieResponseModel?.page ?? 1;

  Future<Either<MovieError, SerieResponseModel>> fetchAllMovies() async {
    movieError = null;
    serieResponseModel = null;
    final result = await _repository.fetchAllMovies();
    result.fold((error) => movieError = error, (movie) {
      if (serieResponseModel == null) {
        serieResponseModel = movie;
      } else {
        serieResponseModel?.page = movie.page;
        serieResponseModel?.movies.addAll(movie.movies);
      }
    },
    );
    return result;
  }
}