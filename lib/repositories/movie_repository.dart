import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';

import '../core/api.dart';
import '../Errors/movier_error.dart';
import '../widgets/models/movie_detail_model.dart';
import '../widgets/models/movie_response_model.dart';

class MovieRepository{
  final Dio _dio = Dio(kDioOptions);

  Future<Either<MovieError, MovieResponseModel>> fetchAllMovies(int page) async{
    try {
      final response = await _dio.get('/movie/popular?api_key=b6f5ab1fe6c171a61e5fb12a5a0b4efa');
      final model = MovieResponseModel.fromMap(response.data);
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

  Future<Either<MovieError, MovieDetailModel>> fetchMovieById(int id) async{
    try{
      final response = await _dio.get('/movie/$id?api_key=b6f5ab1fe6c171a61e5fb12a5a0b4efa');
      final model = MovieDetailModel.fromMap(response.data);
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