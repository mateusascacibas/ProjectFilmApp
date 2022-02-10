import 'dart:convert';

class SerieGenre{
  final int id;
  final String name;

  SerieGenre({
    required this.id,
    required this.name
});
  factory SerieGenre.fromJson(String str) =>
      SerieGenre.fromMap(json.decode(str));
  factory SerieGenre.fromMap(Map<String, dynamic> json) => SerieGenre(
      id: json["id"], name: json["name"],);
}