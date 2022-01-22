// ignore_for_file: public_member_api_docs
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/level/puzzle_levels.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc() : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<NextLevel>(_onNextLevel);
    on<ExplorerMoved>(_onExplorerMoved);
    on<ExplorerReversed>(_onExplorerReversed);
    on<TileTapped>(_onTileTapped);
    on<PuzzleReset>(_onPuzzleReset);
  }

  void _onPuzzleInitialized(PuzzleInitialized event, Emitter<PuzzleState> emit) {
    final puzzle = _generatePuzzleLevel(state.level);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        level: state.level,
      ),
    );
  }

  void _onNextLevel(NextLevel event, Emitter<PuzzleState> emit) {
    if (state.puzzle.explorer.reachedDestination) {
      final puzzle = _generatePuzzleLevel(state.level + 1);
      emit(
        PuzzleState(
          puzzle: puzzle.sort(),
          level: state.level + 1,
        ),
      );
    }
  }

  void _onExplorerMoved(ExplorerMoved event, Emitter<PuzzleState> emit) {

    final mutablePuzzle = Puzzle(
      puzzleNumber: state.puzzle.puzzleNumber,
      tiles: [...state.puzzle.tiles],
      explorer: state.puzzle.explorer,
      maxNumberOfMoves: state.puzzle.maxNumberOfMoves,
    );

    if (state.puzzleStatus == PuzzleStatus.incomplete) {

      final puzzle = mutablePuzzle.moveExplorer();
      if (puzzle.explorer.offBoard) {
        emit(
          state.copyWith(
            level: state.level,
            puzzle: puzzle,
            puzzleStatus: PuzzleStatus.lost,
            tileMovementStatus: TileMovementStatus.nothingTapped,
            numberOfMoves: state.numberOfMoves,
            lastTappedTile: state.lastTappedTile,
          ),
        );
      }
      else if (puzzle.explorer.reachedDestination) {
        emit(
          state.copyWith(
            level: state.level,
            puzzle: puzzle,
            puzzleStatus: PuzzleStatus.complete,
            tileMovementStatus: TileMovementStatus.nothingTapped,
            numberOfMoves: state.numberOfMoves,
            lastTappedTile: state.lastTappedTile,
          ),
        );
      }
      else {
        emit(
          state.copyWith(
            level: state.level,
            puzzle: puzzle,
            puzzleStatus: PuzzleStatus.incomplete,
            tileMovementStatus: TileMovementStatus.nothingTapped,
            numberOfMoves: state.numberOfMoves,
            lastTappedTile: state.lastTappedTile,
          ),
        );
      }
    }
  }

  void _onExplorerReversed(ExplorerReversed event, Emitter<PuzzleState> emit) {
    final mutablePuzzle = state.puzzle.reverseExplorer();
    emit(
      state.copyWith(
        level: state.level,
        puzzle: mutablePuzzle,
        puzzleStatus: PuzzleStatus.incomplete,
        tileMovementStatus: TileMovementStatus.nothingTapped,
        numberOfMoves: state.numberOfMoves,
        lastTappedTile: state.lastTappedTile,
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
            explorer: state.puzzle.explorer,
            maxNumberOfMoves: state.puzzle.maxNumberOfMoves,
        );
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        if (puzzle.isComplete()) {
          emit(
            state.copyWith(
              level: state.level,
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        }
        else {
          if (state.remainingNumberOfMoves == 0) {
            emit(
              state.copyWith(
                level: state.level,
                puzzle: puzzle.sort(),
                puzzleStatus: PuzzleStatus.lost,
                tileMovementStatus: TileMovementStatus.moved,
                numberOfMoves: state.numberOfMoves,
                lastTappedTile: tappedTile,
              ),
            );
          }
          else {
            emit(
              state.copyWith(
                level: state.level,
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
    final puzzle = _generatePuzzleLevel(state.level);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        level: state.level,
      ),
    );
  }

  /// Build the puzzle with the given level.
  Puzzle _generatePuzzleLevel(int level) {
    final currentPuzzle = levels[level - 1];
    final currentTiles = currentPuzzle.tiles;
    final size = currentPuzzle.getDimension();
    var newTiles = currentTiles;

    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {

        final position = Position(x: x, y: y);
        final newTile = Tile(
          value: currentTiles[x - 1 + (y - 1) * size].value,
          startPosition: position,
          currentPosition: position,
          paths: currentTiles[x - 1 + (y - 1) * size].paths,
          markers: currentTiles[x - 1 + (y - 1) * size].markers,
          image: currentTiles[x - 1 + (y - 1) * size].image,
          isWhitespace: currentTiles[x - 1 + (y - 1) * size].isWhitespace,
        );

        newTiles[x - 1 + (y - 1) * size] = newTile;
      }
    }

    final newExplorerTile = newTiles.singleWhere(
        (tile) => tile.value == currentPuzzle.explorer.currentTile.value
    );

    final newDestinationTile = newTiles.singleWhere(
            (tile) => tile.value == currentPuzzle.explorer.destinationTile.value
    );

    final newExplorer = Explorer(
      currentTile: newExplorerTile,
      currentPath: currentPuzzle.explorer.currentPath,
      destinationTile: newDestinationTile,
      destinationPath: currentPuzzle.explorer.destinationPath,
      forwardDirection: currentPuzzle.explorer.forwardDirection,
    );

    final newPuzzle = Puzzle(
      puzzleNumber: currentPuzzle.puzzleNumber,
      tiles: newTiles,
      explorer: newExplorer,
      maxNumberOfMoves: currentPuzzle.maxNumberOfMoves,
    );

    return newPuzzle;
  }
}