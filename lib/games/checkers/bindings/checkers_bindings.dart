import 'package:js/js.dart';

@JS()
@anonymous
class Position {
  external factory Position();
  
  static const none = 0;
  static const up = 1;
  static const down = 2;
}

@JS()
@anonymous
class Coordinates {
  external factory Coordinates({int raw, int col});
  
  external int get raw;
  external int get col;
}

@JS()
@anonymous
class Piece {
  external factory Piece({
    String player,
    Coordinates coordinates,
    int position,
    bool isKing,
    bool isAlive
  });

  external String get player;
  external Coordinates get coordinates;
  external int get position;
  external bool get isKing;
  external bool get isAlive;
}

@JS()
@anonymous
class PieceValue {
  external factory PieceValue({
    int position,
    bool isKing,
    bool isAlive
  });

  external int get position;
  external bool get isKing;
  external bool get isAlive;
} 