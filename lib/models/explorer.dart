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
    this.offBoard = false,
  });

  /// The current [Tile] the explorer is on.
  final Tile currentTile;

  /// The path value of the currentTile the explorer is on.
  final int currentPath;

  /// the next path on the current tile following the current path
  int get nextPath => currentTile.paths[currentPath] ?? currentPath;

  /// Indicates whether the explorer is off the board.
  final bool offBoard;

  @override
  List<Object> get props => [
    currentTile,
    currentPath,
    offBoard,
  ];
}
