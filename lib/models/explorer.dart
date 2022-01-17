import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

/// {@template tile}
/// Model for an explorer on the puzzle.
/// {@endtemplate}
class Explorer extends Equatable {
  /// {@macro tile}
  const Explorer({
    required this.currentTile,
    required this.currentPath,
    required this.destinationTile,
    required this.destinationPath,
    this.offBoard = false,
  });

  /// The current [Tile] the explorer is on.
  final Tile currentTile;

  /// The path value of the currentTile the explorer is on.
  final int currentPath;

  /// The [Tile] the explorer must end on.
  final Tile destinationTile;

  /// The path value of the destinationTile the explorer must end on.
  final int destinationPath;

  /// the next path on the current tile following the current path
  int get nextPath => currentTile.paths[currentPath] ?? currentPath;

  /// Indicates whether the explorer is off the board.
  final bool offBoard;

  /// indicated whether the explorer reached its final destination.
  bool get reachedDestination =>
      (currentTile.value == destinationTile.value) &
      (currentPath == destinationPath);

  @override
  List<Object> get props => [
    currentTile,
    currentPath,
    destinationTile,
    destinationPath,
    offBoard,
  ];
}
