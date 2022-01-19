import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget{
  final String posterPath;
  final void Function()? onTap;

  const MovieCard({
    Key? key,
    required this.posterPath,
    required this.onTap,
}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://image.tmdb.org/t/p/w220_and_h330_face/$posterPath',
            ),
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }
}