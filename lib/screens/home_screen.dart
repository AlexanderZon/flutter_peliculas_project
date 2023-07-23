import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_1/providers/movies_provider.dart';
import 'package:project_1/widgets/widgets.dart';
import 'package:project_1/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true); 
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cines'),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context, 
              delegate: MovieSearchDelegate()
            ), 
            icon: const Icon(Icons.search_outlined)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TODO: CardSwiper
            CardSwiper(movies: moviesProvider.onDisplayMovies,),
            // Listado horizontal de peliculas
            MovieSlider(
              movies: moviesProvider.onPopularMovies, 
              title: 'Populares',
              onNextPage: () {
                moviesProvider.getOnPopularMovies();
              },
            ),
          ] 
        ),
      ),
    );
  }
}