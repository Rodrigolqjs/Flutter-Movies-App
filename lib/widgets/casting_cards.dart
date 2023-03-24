import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;
  const CastingCards({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return FutureBuilder(
      future: moviesProvider.getCastById(movieId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 150),
            height: 180,
            child: const CupertinoActivityIndicator(color: Colors.black),
          );
        }
        //
        final List<Cast> cast = snapshot.data!;
        //
        return Container(
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, int index) {
              if (cast.isNotEmpty) {
                return _CastCard(actor: cast[index]);
              }
            },
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast? actor;
  const _CastCard({super.key, this.actor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      //
      child: Column(
        //
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            //
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/no-image.jpg'),
              image: NetworkImage(actor!.actorProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          //
          const SizedBox(height: 5),
          //
          Text(
            actor?.name ?? 'No name',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}
