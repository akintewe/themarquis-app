class Coordinates {
  final int row;
  final int col;

  const Coordinates({required this.row, required this.col});

  Map<String, dynamic> toJson() => {
        'row': row,
        'col': col,
      };

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        row: json['row'] as int,
        col: json['col'] as int,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinates &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}
