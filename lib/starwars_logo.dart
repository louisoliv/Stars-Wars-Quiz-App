import 'package:flutter/material.dart';

class StarWarsLogo extends StatelessWidget {
  const StarWarsLogo({super.key});

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = isTablet(context);

    return Container(
      child: Image.network(
        'https://logos-download.com/wp-content/uploads/2016/09/Star_Wars_logo-1.png',
        width: tablet ? 600 : 300,
      ),
    );
  }
}
