import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TvCard extends StatelessWidget{
  final String posterPath;
  final void Function()? onTap;

  const TvCard({
    Key? key,
    required this.posterPath,
    required this.onTap,
}) : super(key: key);
  @override
  Widget build(BuildContext context){
    if(this.posterPath != "assets/images/mateus.jpg"){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://image.tmdb.org/t/p/w220_and_h330_face/$posterPath',
            ),
            fit: BoxFit.fill,
          )
        ),
      ),
    );
  }else{
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  this.posterPath,
                ),
                fit: BoxFit.fill,
              )
          ),
        ),
      );
    }
}}