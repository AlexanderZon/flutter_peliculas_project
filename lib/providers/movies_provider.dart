import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_1/helpers/debouncer.dart';
import 'package:project_1/models/models.dart';

class MoviesProvider extends ChangeNotifier {

  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = 'cff718dc8008bcd2a3ca5ef732d3dca8';
  final String _lang = 'es-US';

  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];

  Map<int, List<Cast>> onMoviesCast = {};

  int _popularPages = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  MoviesProvider() {
    getOnDisplayMovies();
    getOnPopularMovies();
  }

  _getMovies(String endpoint, [int page = 1]) async {
    try {
      final url = Uri.https( _baseUrl, endpoint, {
        'api_key': _apiKey, 
        'language': _lang, 
        'page': '$page'
      });
      final response = await http.get(url);

      return response.body;

    } catch (e) {
      print(e);
    }
  }

  getOnDisplayMovies() async {
    var jsonData = await _getMovies('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromRawJson(jsonData);
    
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getOnPopularMovies() async {
    
    _popularPages++;

    var jsonData = await _getMovies('3/movie/popular', _popularPages);

    final popularResponse = PopularResponse.fromRawJson(jsonData);
    
    onPopularMovies = [...onPopularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getOnMovieCredits(int movieId) async {

    if(onMoviesCast.containsKey(movieId)) return onMoviesCast[movieId]!;

    var jsonData = await _getMovies('3/movie/$movieId/credits');

    final creditsResponse = CreditsResponse.fromRawJson(jsonData);

    onMoviesCast[movieId] = creditsResponse.cast;
    
    return creditsResponse.cast;
  }

  Future<List<Movie>> getOnSearchMovies(String query) async {
    final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apiKey, 
      'language': _lang, 
      'query': '$query'
    });
    final response = await http.get(url);
    final searchResponse = SearchMoviesResponse.fromRawJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await this.getOnSearchMovies(value);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (timer) { 
      debouncer.value = query;
    });

    Future.delayed(Duration(milliseconds: 301)).then((value) => timer.cancel());
  }
}