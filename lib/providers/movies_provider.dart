import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = 'b676afabe7631ca8e4fd4a94d107209f';
  final String _language = 'es-ES';

  List<Movie> movies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );
  final StreamController<List<Movie>> _suggestionStreamController =
      new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    // ignore: avoid_print
    getMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });
    final response = await http.get(url);
    return response.body;
  }

  getMovies() async {
    // ignore: avoid_print

    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    movies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    // ignore: avoid_print
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final nowPlayingPopularResponse =
        NowPlayingPopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...nowPlayingPopularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getCastById(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    print('pidiendo datos');

    var url = Uri.https(_baseUrl, '3/movie/$movieId/credits', {
      'api_key': _apiKey,
      'language': _language,
    });

    final response = await http.get(url);
    final decodedData = CastResponse.fromJson(response.body);

    moviesCast[movieId] = decodedData.cast;
    return decodedData.cast;
  }

  Future<List<Movie>> getMovieByQuery({required String query}) async {
    var url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': '$query'});

    final response = await http.get(url);
    final decodedData = SearchMovieResponse.fromJson(response.body);

    return decodedData.results;
  }

  void getSuggestionsByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await getMovieByQuery(query: value);
      _suggestionStreamController.add(results);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
