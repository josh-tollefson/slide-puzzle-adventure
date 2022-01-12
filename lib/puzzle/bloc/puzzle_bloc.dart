// ignore_for_file: public_member_api_docs
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/level/puzzle_levels.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(this._level) : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<PuzzleReset>(_onPuzzleReset);
  }

  final int _level;

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {
    final puzzle = _generatePuzzleLevel(_level);
    emit(
PuzzleState(
        puzzle: puzzle.sort(),
        // numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        final mutablePuzzle = Puzzle(
            puzzleNumber: state.puzzle.puzzleNumber,
            tiles: [...state.puzzle.tiles],
            maxNumberOfMoves: state.puzzle.maxNumberOfMoves
        );
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        if (puzzle.isComplete()) {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              // numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              // numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  void _onPuzzleReset(PuzzleReset event, Emitter<PuzzleState> emit) {
    final puzzle = _generatePuzzleLevel(_level);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        // numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generatePuzzleLevel(int level) {

    // final size = sqrt(LEVEL_1.length).toInt();
    // final values =
    // final paths =  <Map>[];
    // final startPositions = <Position>[];
    // final currentPositions = <Position>[];
    // final whitespacePosition = Position(x: size, y: size);
    //
    // // Create all possible board positions.
    // for (var y = 1; y <= size; y++) {
    //   for (var x = 1; x <= size; x++) {
    //     if (x == size && y == size) {
    //       startPositions.add(whitespacePosition);
    //       currentPositions.add(whitespacePosition);
    //     } else {
    //       final position = Position(x: x, y: y);
    //       startPositions.add(position);
    //       currentPositions.add(position);
    //     }
    //   }
    // }

    final currentPuzzle = levels[level - 1];
    final size = sqrt(currentPuzzle.tiles.length).toInt();

    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        final position = Position(x: x, y: y);
        currentPuzzle.tiles[x - 1 + (y - 1) * size].startPosition = position;
        currentPuzzle.tiles[x - 1 + (y - 1) * size].currentPosition = position;
      }
    }

    return currentPuzzle;
  }

  /// Build a randomized, solvable puzzle of the given size.
  // Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
  //   final correctPositions = <Position>[];
  //   final currentPositions = <Position>[];
  //   final whitespacePosition = Position(x: size, y: size);
  //
  //   // Create all possible board positions.
  //   for (var y = 1; y <= size; y++) {
  //     for (var x = 1; x <= size; x++) {
  //       if (x == size && y == size) {
  //         correctPositions.add(whitespacePosition);
  //         currentPositions.add(whitespacePosition);
  //       } else {
  //         final position = Position(x: x, y: y);
  //         correctPositions.add(position);
  //         currentPositions.add(position);
  //       }
  //     }
  //   }
  //
  //   if (shuffle) {
  //     // Randomize only the current tile positions.
  //     currentPositions.shuffle(random);
  //   }
  //
  //   var tiles = _getTileListFromPositions(
  //     size,
  //     correctPositions,
  //     currentPositions,
  //   );
  //
  //   var puzzle = Puzzle(tiles: tiles);
  //
  //   if (shuffle) {
  //     // Assign the tiles new current positions until the puzzle is solvable and
  //     // zero tiles are in their correct position.
  //     while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
  //       currentPositions.shuffle(random);
  //       tiles = _getTileListFromPositions(
  //         size,
  //         correctPositions,
  //         currentPositions,
  //       );
  //       puzzle = Puzzle(tiles: tiles);
  //     }
  //   }
  //
  //   return puzzle;
  // }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<int> values,
    List<Position> startPositions,
    List<Position> currentPositions,
    List<Map<int,int>> paths,
    List<Map<int,String>> markers,
    List<String> images,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: values[i],
            startPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: values[i],
            startPosition: startPositions[i - 1],
            currentPosition: currentPositions[i - 1],
            paths: paths[i],
            markers: markers[i],
          )
    ];
  }
}
