import 'package:flutter/material.dart';
import 'package:project_1/models/models.dart';
import 'package:project_1/widgets/casting_cards.dart';

class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(movie),
              _Overview(movie),
              CastingCard(movie.id)
            ])
          )
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomAppBar(this.movie);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only( bottom: 10, left: 10, right: 10 ),
          color: Colors.black12,
          child: Text(
            movie.title,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'), 
          image: NetworkImage(movie.fullBackdropImage ?? 'assets/no-image.jpg'),
          fit: BoxFit.cover
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {

  final Movie movie;

  const _PosterAndTitle(this.movie);

  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric( horizontal: 20 ),
      child: Row(
        children: [

          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/loading.gif'), 
                image: NetworkImage(movie.fullPosterImg ?? 'assets/no-image.jpg'),
                height: 150,
              ),
            ),
          ),

          const SizedBox( width: 20 ),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 170),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                Text(
                  movie.title, 
                  style: textTheme.headlineSmall, 
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
          
                Text(
                  movie.originalTitle, 
                  style: textTheme.labelLarge, 
                  overflow: TextOverflow.ellipsis,
                ),
          
                Row(
                  children: [
                    const Icon(Icons.star_outline, size: 15, color: Colors.grey),
                    const SizedBox( width: 5 ),
                    Text(movie.voteAverage.toString(), style: textTheme.bodySmall,)
                  ],
                )
          
              ],
            ),
          )
        ],
      )
    );
  }
}

class _Overview extends StatelessWidget {

  final Movie movie;

  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        movie.overview,        
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
