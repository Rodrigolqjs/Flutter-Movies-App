import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';

import '../providers/movies_provider.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final Function onNextPage;

  const MovieSlider({Key? key, required this.movies, required this.onNextPage})
      : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollcontroller.addListener(() {
      if (scrollcontroller.position.pixels >=
          scrollcontroller.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: 290,
      //
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 5),
            //
            child: Text(
              'Populares',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          //
          Expanded(
            child: ListView.builder(
              controller: scrollcontroller,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (context, index) {
                widget.movies[index].movieHeroId =
                    'id${widget.movies[index].id}-$index';
                return _MoviePoster(
                  movie: widget.movies[index],
                );
              },
            ),
          ),
          //
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  const _MoviePoster({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //
      child: Column(
        children: [
          //
          GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, 'details', arguments: movie),
              child: Hero(
                tag: movie.movieHeroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  //
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/images/no-image.jpg'),
                    image: NetworkImage(movie.moviePosterPath),
                    width: 130,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          //
          const SizedBox(height: 10),
          //
          if (movie.title != "")
            Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            )
        ],
      ),
    );
  }
}
