import 'package:dartz/dartz.dart';
import 'package:filmproject/repositories/serie_repository.dart';
import 'package:filmproject/widgets/models/serie_detail_model.dart';

import '../Errors/movier_error.dart';
import '../widgets/models/movie_detail_model.dart';
import '../repositories/movie_repository.dart';

class SerieDetailController{
  final _repository = SerieRepository();
  SerieDetailModel? serieDetail;
  late MovieError? serieError;

  bool loading = true;

  Future<Either<MovieError, SerieDetailModel>> fetchMovieBydId(int id) async{
    serieError = null;
    final result = await _repository.fetchMovieById(id);
    result.fold((error) => serieError = error, (detail) => serieDetail = detail,);
    return result;
  }
}