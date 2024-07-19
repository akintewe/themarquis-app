import 'package:flutter/material.dart';
import 'package:marquis_v2/router/route_path.dart';

class GamePath extends AppRoutePath {
  final String id;
  const GamePath(this.id);
  @override
  String getRouteInformation() {
    return '/game/$id';
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.id});
  final String id;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Game"),
      ),
    );
  }
}
