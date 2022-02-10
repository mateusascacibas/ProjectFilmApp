import 'package:dartz/dartz.dart';
import 'package:filmproject/Errors/movier_error.dart';
import 'package:filmproject/controllers/serie_detail_controller.dart';
import 'package:filmproject/repositories/serie_repository.dart';
import 'package:filmproject/widgets/models/movie_model.dart';
import 'package:filmproject/widgets/models/movie_response_model.dart';
import 'package:filmproject/repositories/movie_repository.dart';
import 'package:filmproject/widgets/models/serie_model.dart';
import 'package:filmproject/widgets/models/serie_response_model.dart';
import 'package:flutter/cupertino.dart';

import 'movie_detail_controller.dart';

class SerieControllerSearch {
  final _repository = SerieRepository();

  late SerieResponseModel? movieResponseModel;
  late MovieError? movieError;
  bool loading = true;

  List<SerieModel> get movies => movieResponseModel?.movies ?? <SerieModel>[];

  int get moviesCounts => movies.length;

  bool get hasMovies => moviesCounts != 0;

  int get totalPages => movieResponseModel?.totalPages ?? 1;

  int get currentPage => movieResponseModel?.page ?? 1;

  Future<Either<MovieError, SerieResponseModel>> fetchSearchMovies(
      {int page = 1, required String text}) async {
    movieError = null;
    movieResponseModel = null;
    final _controller = SerieDetailController();
    final result = await _repository.fetchAllMovies();
    result.fold((error) => movieError = error, (movie) {
      if (_controller.serieDetail!.title.contains(text)) {
        movieResponseModel = movie;
      }
    },
    );
    return result;
  }
}