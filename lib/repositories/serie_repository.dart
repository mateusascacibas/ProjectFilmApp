import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:filmproject/serie_detail_page.dart';
import 'package:filmproject/widgets/models/serie_detail_model.dart';
import 'package:filmproject/widgets/models/serie_response_model.dart';

import '../core/api.dart';
import '../Errors/movier_error.dart';
import '../widgets/models/movie_detail_model.dart';
import '../widgets/models/movie_response_model.dart';

class SerieRepository{
  final Dio _dio = Dio(kDioOptions);

  Future<Either<MovieError, SerieResponseModel>> fetchAllMovies() async{
    try {
      final response = await _dio.get('/tv/popular?api_key=b6f5ab1fe6c171a61e5fb12a5a0b4efa');
      final model = SerieResponseModel.fromMap(response.data);
      return Right(model);
    } on DioError catch (error){
      if(error.response != null){
        return Left(MovieRepositoryError(error.response.data["status_message"]));
      }
      else{
        return Left(MovieRepositoryError(kServerError));
      }
    } on Exception catch(error){
      return Left(MovieRepositoryError(error.toString()));
    }
  }

  Future<Either<MovieError, SerieDetailModel>> fetchMovieById(int id) async{
    try{
      final response = await _dio.get('/tv/$id?api_key=b6f5ab1fe6c171a61e5fb12a5a0b4efa');
      final model = SerieDetailModel.fromMap(response.data);
      return Right(model);
    } on DioError catch (error){
      if(error.response != null){
        return Left(MovieRepositoryError(error.response.data["status_message"]));
      }
      else{
        return Left(MovieRepositoryError(kServerError));
      }
    } on Exception catch(error){
      return Left(MovieRepositoryError(error.toString()));
    }
    }
}