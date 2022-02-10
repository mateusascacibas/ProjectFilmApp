import 'dart:convert';
import 'package:filmproject/widgets/models/serie_model.dart';

import 'movie_model.dart';

class SerieResponseModel{
  int page;
  final int totalResults;
  final int totalPages;
  final List<SerieModel> movies;

  SerieResponseModel({
    required this.page,
    required this.totalResults,
    required this.totalPages,
    required this.movies
});

  factory SerieResponseModel.fromJson(String str) =>
      SerieResponseModel.fromMap(json.decode(str));
  factory SerieResponseModel.fromMap(Map<String, dynamic> json) =>
      SerieResponseModel(
          page: json["page"],
          totalResults: json["total_results"],
          totalPages: json["total_pages"],
          movies: List<SerieModel>.from(
            json["results"].map((x) => SerieModel.fromMap(x)),
          ));
}