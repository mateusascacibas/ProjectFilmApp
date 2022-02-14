import 'dart:convert';

class SerieModel{
  final double popularity;
  final int voteCount;
  final String posterPath;
  final int id;
  final String backdropPath;
  final String originalLanguage;
  final String originalTitle;
  final List<int> genreIds;
  final String title;
  final double voteAverage;
  final String overview;

  const SerieModel({
    required this.popularity,
    required this.voteCount,
    required this.posterPath,
    required this.id,
    required this.backdropPath,
    required this.originalLanguage,
    required this.originalTitle,
    required this.genreIds,
    required this.title,
    required this.voteAverage,
    required this.overview,
});

  factory SerieModel.fromJson(String str) =>
      SerieModel.fromMap(json.decode(str));
  factory SerieModel.fromMap(Map<String, dynamic> json) =>  SerieModel(
    popularity: json["popularity"].toDouble(),
    voteCount: json["vote_count"],
    posterPath: json["poster_path"],
    id: json["id"],
    backdropPath: json["backdrop_path"],
    originalLanguage: json["original_language"],
    originalTitle: json["original_name"],
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    title: json["name"],
    voteAverage: json["vote_average"].toDouble(),
    overview: json["overview"],
  );
}