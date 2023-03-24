// To parse this JSON data, do
//
//     final nowPlayingPopularResponse = nowPlayingPopularResponseFromMap(jsonString);

import 'dart:convert';

import 'package:peliculas_app/models/models.dart';

class NowPlayingPopularResponse {
  NowPlayingPopularResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory NowPlayingPopularResponse.fromJson(String str) =>
      NowPlayingPopularResponse.fromMap(json.decode(str));

  factory NowPlayingPopularResponse.fromMap(Map<String, dynamic> json) =>
      NowPlayingPopularResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
