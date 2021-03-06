// ignore_for_file: public_member_api_docs

part of 'puzzle_bloc.dart';

enum PuzzleStatus { incomplete, complete, lost }

enum TileMovementStatus { nothingTapped, cannotBeMoved, moved }

class PuzzleState extends Equatable {
  const PuzzleState({
    this.level = 1,
    this.puzzle = const Puzzle(
        tiles: [],
        explorer: Explorer(
          currentTile: Tile(),
          currentPath: 0,
          destinationTile: Tile(),
          destinationPath: 0,
          forwardDirection: true,
        ),
    ),
    this.puzzleStatus = PuzzleStatus.incomplete,
    this.tileMovementStatus = TileMovementStatus.nothingTapped,
    this.numberOfMoves = 0,
    this.lastTappedTile,
  });

  /// The current puzzle level.
  final int level;

  /// [Puzzle] containing the current tile arrangement.
  final Puzzle puzzle;

  /// Status indicating the current state of the puzzle.
  final PuzzleStatus puzzleStatus;

  /// Status indicating if a [Tile] was moved or why a [Tile] was not moved.
  final TileMovementStatus tileMovementStatus;

  /// Represents the last tapped tile of the puzzle.
  ///
  /// The value is `null` if the user has not interacted with
  /// the puzzle yet.
  final Tile? lastTappedTile;

  /// Number of tiles currently not in their correct position.
  int get remainingNumberOfMoves => puzzle.maxNumberOfMoves - numberOfMoves;

  /// Number representing how many moves have been made on the current puzzle.
  ///
  /// The number of moves is not always the same as the total number of tiles
  /// moved. If a row/column of 2+ tiles are moved from one tap, one move is
  /// added.
  final int numberOfMoves;

  PuzzleState copyWith({
    int? level,
    Puzzle? puzzle,
    PuzzleStatus? puzzleStatus,
    TileMovementStatus? tileMovementStatus,
    int? numberOfCorrectTiles,
    int? numberOfMoves,
    Tile? lastTappedTile,
  }) {
    return PuzzleState(
      level: level ?? this.level,
      puzzle: puzzle ?? this.puzzle,
      puzzleStatus: puzzleStatus ?? this.puzzleStatus,
      tileMovementStatus: tileMovementStatus ?? this.tileMovementStatus,
      numberOfMoves: numberOfMoves ?? this.numberOfMoves,
      lastTappedTile: lastTappedTile ?? this.lastTappedTile,
    );
  }

  @override
  List<Object?> get props => [
        level,
        puzzle,
        puzzleStatus,
        tileMovementStatus,
        numberOfMoves,
        lastTappedTile,
      ];
}
