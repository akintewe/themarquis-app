enum Position {
  up(0),
  down(1),
  none(2);

  final int value;
  const Position(this.value);

  factory Position.fromValue(int value) {
    return Position.values.firstWhere((e) => e.value == value);
  }
}
