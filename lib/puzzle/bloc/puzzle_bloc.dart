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

  void _onPuzzleInitialized(PuzzleInitialized event,
      Emitter<PuzzleState> emit,) {
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
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        } else {
          if (state.remainingNumberOfMoves == 0) {
            emit(
              state.copyWith(
                puzzle: puzzle.sort(),
                puzzleStatus: PuzzleStatus.lost,
                tileMovementStatus: TileMovementStatus.moved,
                numberOfMoves: state.numberOfMoves,
                lastTappedTile: tappedTile,
              ),
            );
          } else {
            emit(
              state.copyWith(
                puzzle: puzzle.sort(),
                tileMovementStatus: TileMovementStatus.moved,
                numberOfMoves: state.numberOfMoves + 1,
                lastTappedTile: tappedTile,
              ),
            );
          }
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
}