import 'dart:convert';
import 'movie_genre.dart';
import 'production_company_model.dart';
import 'production_country_model.dart';
import 'spoken_language__model.dart';

class SerieDetailModel{
  final String backdropPath;
  final List<MovieGenre> genres;
  final String homepage;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<ProductionCompanyModel> productionCompanies;
  final List<ProductionCountryModel> productionCountries;
  final List<SpokenLanguageModel> spokenLanguages;
  final String status;
  final String tagline;
  final String title;
  final double voteAverage;
  final int voteCount;

  const SerieDetailModel({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.homepage,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
});

  factory SerieDetailModel.fromJson(String str) =>
      SerieDetailModel.fromMap(json.decode(str));
  factory SerieDetailModel.fromMap(Map<String, dynamic> json)=>
      SerieDetailModel(
        backdropPath: json["backdrop_path"],
        genres: List<MovieGenre>.from(
          json["genres"].map((x) => MovieGenre.fromMap(x))
        ),
        homepage: json["homepage"],
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        productionCompanies: List<ProductionCompanyModel>.from(
          json["production_companies"].map((x) => ProductionCompanyModel.fromMap(x))
        ),
        productionCountries: List<ProductionCountryModel>.from(
            json["production_countries"].map((x) => ProductionCountryModel.fromMap(x))
        ),
        spokenLanguages: List<SpokenLanguageModel>.from(json["spoken_languages"]
        .map((x) => SpokenLanguageModel.fromMap(x))),
        status: json["status"],
        tagline: json["tagline"],
        title: json["name"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );
}