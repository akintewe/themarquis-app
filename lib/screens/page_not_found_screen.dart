import 'package:flutter/material.dart';
import 'package:marquis_v2/router/route_path.dart';

class PageNotFoundPath extends AppRoutePath {
  @override
  String getRouteInformation() {
    return '/not-found';
  }
}

class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("404 - not found"),
      ),
    );
  }
}
